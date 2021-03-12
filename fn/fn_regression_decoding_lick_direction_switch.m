function fn_regression_decoding_lick_direction_switch (key,self, rel_all_lick)

Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
% minimal_num_units_proj_trial = 10; %Param.parameter_value{(strcmp('minimal_num_units_proj_trial',Param.parameter_name))};
k=key;
% if strcmp(k.lick_direction,'all')
%     k=rmfield(k,'lick_direction');
% end

k_proj=k;
k_proj.lick_direction='all';
k_proj.regression_time_start=k.regression_time_start;
restrict_by_licks=EXP.TrialID & rel_all_lick;

rel_Proj = ((ANL.RegressionProjTrialGo	 & restrict_by_licks) &k_proj  )*EXP.TrialID*EXP.TrialName*EXP.BehaviorTrial;
% if rel_Proj.count>0
%     a=1
% end

rel_Proj = rel_Proj & 'num_units_projected>=10';

if rel_Proj.count<=2
    return
end

rel_TONGUE= ((rel_all_lick) & (EXP.TrialID & rel_Proj.proj))*EXP.TrialID;

if rel_TONGUE.count<=10
    return
end


TONGUE = struct2table(fetch(rel_TONGUE,'*' , 'ORDER BY trial_uid'));

proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
proj_trial_num=fetchn(rel_Proj,'trial', 'ORDER BY trial_uid');


t=-1:0.1:1;
time_window=0.2;
for i_t=1:1:numel(t)
    
    for i_LickXTrial=1:1:size(TONGUE, 1)
        t_lick_onset= table2array(TONGUE(i_LickXTrial,'lick_rt_video_peak'));
        time_idx_2plot = ((time-t_lick_onset) >=t(i_t) & (time -t_lick_onset)<t(i_t) + time_window);
        current_trial_num=table2array(TONGUE(i_LickXTrial,'trial'));
        idx_proj_trial= find(proj_trial_num==current_trial_num);
        P.endpoint(i_LickXTrial)=nanmean(proj_trial(idx_proj_trial,time_idx_2plot),2);
    end
    
    %exlude outliers
%     P_outlier_idx= isoutlier(P.endpoint);
    
%     P.endpoint=P.endpoint(~P_outlier_idx);
    TONGUE_current=TONGUE;%(~P_outlier_idx,:);
    
    Y=table2array(TONGUE_current(:,k.tuning_param_name));
    X=(P.endpoint)';
    [X,Y,Linear] = fn_compute_linear_regression (X,Y);
    
    
    
    %% Computing R2 of both types of fits (linear and logistic)
    R2_LinearRegression(i_t)=Linear.R2;
    %     R2_LogisticRegression(i_t)=Logistic.R2;
end

key.number_of_licks_with_switch=size(TONGUE, 1);
key.rsq_linear_regression_t=R2_LinearRegression;
key.t_for_decoding=t;
insert(self,key);