%{
#
-> EPHYS.Unit
---
psth_t_vector                   : longblob    # time vector (seconds) of bin centers used to compute the PSTH, aligned to the go cue time
%}


classdef PSTH < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dt=fetch1(ANL.Parameters & 'parameter_name="psth_time_bin"','parameter_value');
            t_edges = [-6.5:dt:4];
            psth_t_vector = t_edges(1:end-1)+dt/2;
            go_times =fetchn(EXP.BehaviorTrialEvent & key & 'trial_event_type="go"','trial_event_time','ORDER BY trial');
            ntrials =numel(go_times)';
            nunits = numel([fetchn(EPHYS.Unit & key,'unit')]);
            electrode_group = [fetchn(EPHYS.Unit & key,'electrode_group')];
            task = fetch1(EXP.Task & key,'task');
%             trial_names = [fetchn((MISC.S1TrialTypeName) & key, 'trial_type_name','ORDER BY trial')];
            trial_names = [fetchn((EXP.TrialName) & key, 'trial_type_name','ORDER BY trial')];

            outcome = fetchn(EXP.Outcome,'outcome');
            
            %% Compute PSTH and populate ANL.PSTH
            sp_first=[];
            sp_last=[];
            psth_t_u_tr = zeros(numel(psth_t_vector), nunits, ntrials)+NaN;
            for iu=1:1:nunits
                
                k_PSTH(iu).subject_id=key.subject_id;
                k_PSTH(iu).session=key.session;
                k_PSTH(iu).electrode_group = electrode_group(iu);
                k_PSTH(iu).unit = iu;
                k_PSTH(iu).psth_t_vector = psth_t_vector;
                
                kunit.unit = iu;
                TrialSpikes =(fetch(EPHYS.TrialSpikes & key & kunit,'*'));
                unit_trials{iu}= [TrialSpikes.trial];
                for itr=unit_trials{iu}
                    spike_times=TrialSpikes(unit_trials{iu}==itr).spike_times-go_times(itr);
                    if ~isempty(spike_times)
                        sp_first = [sp_first spike_times(1)];
                        sp_last = [sp_last spike_times(end)];
                    end
                    psth_t_u_tr(:, iu, itr) = histcounts(spike_times, t_edges)/dt;
                end
            end
            no_recording_times_mask=zeros(1,numel(psth_t_vector));
            no_recording_times_mask ((psth_t_vector<min(sp_first) |  psth_t_vector>max(sp_last)))=NaN;
            
            insert(self,k_PSTH);
            
            
            
            %% Populate ANL.PSTHTrial
            counter=0;
            for iu =1:1:nunits
                for  itr =unit_trials{iu}
                    counter=counter+1;
                    k_PSTHTrial(counter).subject_id=key.subject_id;
                    k_PSTHTrial(counter).session=key.session;
                    k_PSTHTrial(counter).electrode_group = electrode_group(iu);
                    k_PSTHTrial(counter).unit = iu;
                    k_PSTHTrial(counter).task = task;
                    
                    k_PSTHTrial(counter).trial_type_name=trial_names{itr};
                    k_PSTHTrial(counter).trial = itr;
                    psth_trial = squeeze (psth_t_u_tr(:, iu, itr))';
                    k_PSTHTrial(counter).psth_trial=psth_trial+no_recording_times_mask;
                end
            end
            insert(ANL.PSTHTrial,k_PSTHTrial);
            
            
            %% Populate  ANL.PSTHAverage 
            rel = (EXP.TrialName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key;
            trial_type_names = unique([fetchn(rel, 'trial_type_name','ORDER BY trial')],'stable');

            counter=0;
            for  ityp = 1:1:numel(trial_type_names)
                key_name.trial_type_name=trial_type_names{ityp};
                for out_type =1:1:numel(outcome)
                    key_condition.outcome = outcome{out_type};
                    key_condition.early_lick = 'no early';
                    trials_condition  = [fetchn(rel & key_condition, 'trial','ORDER BY trial')];
                    trials_condition_type  = [fetchn(rel & key_condition & key_name, 'trial','ORDER BY trial')];
                    for iu =1:1:nunits
                        
                        unit_trials_conditon_type  = intersect(unit_trials{iu},trials_condition_type);
                        psth_u = squeeze (psth_t_u_tr(:, iu, :));
                        psth_avg = mean(squeeze (psth_t_u_tr(:, iu, unit_trials_conditon_type)),2)';
                        
                        counter=counter+1;
                        
                        k_PSTHAverage(counter).subject_id=key.subject_id;
                        k_PSTHAverage(counter).session=key.session;
                        k_PSTHAverage(counter).electrode_group = electrode_group(iu);
                        k_PSTHAverage(counter).unit = iu;
                        k_PSTHAverage(counter).task = task;
                        k_PSTHAverage(counter).trial_type_name=key_name.trial_type_name;
                        k_PSTHAverage(counter).outcome=key_condition.outcome;
                        k_PSTHAverage(counter).num_trials_averaged =numel(unit_trials_conditon_type);
                        k_PSTHAverage(counter).psth_avg=psth_avg+no_recording_times_mask;
                        k_PSTHAverage(counter).psth_avg_id=counter;
                        
                    end
                end
            end
            insert(ANL.PSTHAverage,k_PSTHAverage);
            
            
            %% Populate  ANL.PSTHAverageLR
            % Average all L vs. all R trials, even those trials with photostimulations. This is to have more trials for error-trial analysis
            counter=0;
            for  i_LR = 1:1:2
                if i_LR==1
                    trial_type_name='l';
                    key_instruction.trial_instruction = 'left';
                else
                    trial_type_name='r';
                    key_instruction.trial_instruction = 'right';
                end
                for out_type =1:1:numel(outcome)
                    key_condition.outcome = outcome{out_type};
                    key_condition.early_lick = 'no early';
                    trials_condition_type  = [fetchn(rel & key_condition & key_instruction, 'trial','ORDER BY trial')];
                    for iu =1:1:nunits
                        
                        unit_trials_conditon_type  = intersect(unit_trials{iu},trials_condition_type);
                        psth_avg = mean(squeeze (psth_t_u_tr(:, iu, unit_trials_conditon_type)),2)';
                        counter=counter+1;
                        
                        
                        k_PSTHAverageLR(counter).subject_id=key.subject_id;
                        k_PSTHAverageLR(counter).session=key.session;
                        k_PSTHAverageLR(counter).electrode_group = electrode_group(iu);
                        k_PSTHAverageLR(counter).unit = iu;
                        k_PSTHAverageLR(counter).task = task;
                        k_PSTHAverageLR(counter).trial_type_name=trial_type_name;
                        k_PSTHAverageLR(counter).outcome=key_condition.outcome;
                        k_PSTHAverageLR(counter).num_trials_averaged =numel(unit_trials_conditon_type);
                        k_PSTHAverageLR(counter).psth_avg=psth_avg+no_recording_times_mask;
                        k_PSTHAverageLR(counter).psth_avg_id=counter;
                        
                    end
                end
            end
            insert(ANL.PSTHAverageLR,k_PSTHAverageLR);
            
            
            
        end
        
    end
end