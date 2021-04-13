function Sup3_Modes_definition_and_variance3()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_embeded_graphics = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\Graphic_for_figures\'
dir_save_figure = [dir_root 'Results\figures\v\'];
filename = 'Sup3_Modes_definition_and_variance3';

mode_names = {'ChoiceMatched', 'Stimulus Orthog.111','Ramping Orthog.111'};
mode_titles = {'Choice','Stimulus', 'Ramping'};


%Graphics
%---------------------------------
figure1=figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
set(gcf,'color',[1 1 1]);

panel_width1=0.15;
panel_height1=0.09;
horizontal_distance1=0.17;
vertical_distance1=0.11;

position_x1(1)=0.035;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1;
position_x1(5)=position_x1(4)+horizontal_distance1;
position_x1(6)=position_x1(5)+horizontal_distance1;
position_x1(7)=position_x1(6)+horizontal_distance1*0.6;

position_y1(1)=0.77;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1*1.5;
position_y1(4)=position_y1(3)-vertical_distance1*1.5;


panel_width2=0.12;
horizontal_distance2=0.18;

position_x2(1)=0.08;
position_x2(2)=position_x2(1)+horizontal_distance2;
position_x2(3)=position_x2(2)+horizontal_distance2;
position_x2(4)=position_x2(3)+horizontal_distance2*1;
position_x2(5)=position_x2(4)+horizontal_distance2*0.9;


horizontal_distance3=0.2;
position_x3(1)=0.1;
position_x3(2)=position_x3(1)+horizontal_distance3;
position_x3(3)=position_x3(2)+horizontal_distance3*1.2;
position_x3(4)=position_x3(3)+horizontal_distance3;

% Params
Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};

% c=distinguishable_colors(8);
colr{1}=[ 0    0.3448         0];
colr{2}=[ 0    1.0000         0];
colr{3}=[0.5000         0    0.5000];


%% Activity space - cartoons
% axes('position', [position_x1(1) position_y1(1) panel_width1, panel_width1]); hold on ;
% xl = [0 1456];
% yl = [0 1159];
% fig1_a = imread([dir_embeded_graphics 'activity_space.jpg']);
% fig1_a=flipdim(fig1_a,1);
% imagesc(fig1_a);
% set(gca,'Xlim',xl,'Ylim',yl);
% text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'Activity space','FontSize',7,'FontWeight','bold','Color',[0 0 0],'HorizontalAlignment','center');
% axis off;
% axis tight;
% axis equal;
% text(xl(1)-diff(xl)*0.0, yl(1)+diff(yl)*1.15, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Activity space - Stimulus mode
axes('position', [position_x1(1) position_y1(1) panel_width1, panel_width1]); hold on ;
xl = [0 1456];
yl = [0 1159];
fig1_a = imread([dir_embeded_graphics 'activity_space_stimulus.jpg']);
fig1_a=flipdim(fig1_a,1);
imagesc(fig1_a);
set(gca,'Xlim',xl,'Ylim',yl);
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'Stimulus mode','FontSize',7,'FontWeight','bold','Color',colr{1},'HorizontalAlignment','center');
axis off;
axis tight;
axis equal;
text(xl(1)-diff(xl)*0.0, yl(1)+diff(yl)*1.1, 'A', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Activity space - Choice mode
axes('position', [position_x1(2) position_y1(1) panel_width1, panel_width1]); hold on ;
xl = [0 1456];
yl = [0 1159];
fig1_a = imread([dir_embeded_graphics 'activity_space_choice.jpg']);
fig1_a=flipdim(fig1_a,1);
imagesc(fig1_a);
set(gca,'Xlim',xl,'Ylim',yl);
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'Choice mode','FontSize',7,'FontWeight','bold','Color',colr{2},'HorizontalAlignment','center');
axis off;
axis tight;
axis equal;


% Activity space - Ramping mode
axes('position', [position_x1(3) position_y1(1) panel_width1, panel_width1]); hold on ;
xl = [0 1456];
yl = [0 1159];
fig1_a = imread([dir_embeded_graphics 'activity_space_ramping.jpg']);
fig1_a=flipdim(fig1_a,1);
imagesc(fig1_a);
set(gca,'Xlim',xl,'Ylim',yl);
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,sprintf('Ramping mode (non-selective)'),'FontSize',7,'FontWeight','bold','Color',colr{3},'HorizontalAlignment','center');
axis off;
axis tight;
axis equal;




%% Left ALM
flag_normalize_modes=1;
key=[]; k=[];
% key.unit_quality = 'ok or good';
key.unit_quality = 'all';
key.cell_type = 'Pyr';
key.mode_weights_sign = 'all';
key.brain_area = 'ALM';
key.hemisphere = 'left';
key.training_type = 'distractor';

key.outcome='hit';
outcome='hit';

key.session_flag_full = 1;
key.trialtype_left_and_right_no_distractors = 1;
key.trialtype_flag_full = 1;

k=key;

if contains(k.unit_quality, 'ok or good')
    rel_Proj =(EXP.Session * EXP.SessionID * ANL.ProjTrialAverageBaseline10 * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * ANL.SessionGrouping * ANL.TrialTypeStimTime) & k & (ANL.IncludeSessionSelectivity2 & 'num_delay_selective_units>=6' & 'num_sample_selective_units>=0');
    k = rmfield(k,'unit_quality')
    rel_PSTH = (( ANL.PSTHAverage * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining  *ANL.SessionGrouping * ANL.TrialTypeGraphic ) ) & ANL.IncludeUnit2 & k & 'unit_quality!="multi"' & k & (ANL.IncludeSessionSelectivity2 & 'num_delay_selective_units>=6' & 'num_sample_selective_units>=0');
elseif contains(k.unit_quality, 'all')
rel_Proj =(EXP.Session * EXP.SessionID * ANL.ProjTrialAverageBaseline10 * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * ANL.SessionGrouping * ANL.TrialTypeStimTime) & k & (ANL.IncludeSessionSelectivity2 & 'num_delay_selective_units>=6' & 'num_sample_selective_units>=0');
        k = rmfield(k,'unit_quality')
        rel_PSTH = (( ANL.PSTHAverage * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining  *ANL.SessionGrouping)) & ANL.IncludeUnit2 & k & (ANL.IncludeSessionSelectivity2 & 'num_delay_selective_units>=6' & 'num_sample_selective_units>=0');

end


title1 = '';
title2='';
title3=[];
plot_r_flag=1;
title1 = '';
title2='';
title3=[];
key_trial_type.trial_type_name=[];
line_style='-';
xlabel_flag=1;
ylabel_flag=1;
stim_legend_flag=1;




% Stimulus mode
axes('position',[position_x2(1), position_y1(2), panel_width2, panel_height1]);
k=key;
k.mode_type_name = mode_names{2};
mode_title = mode_titles(2);
rel_Proj_current = rel_Proj & k;
y_lims = [-0.1,1];
xl=[-3.5,0];
[xl, yl] =figure_plotModes_correct_or_error (rel_Proj_current,  Param, xlabel_flag, title1, title2, title3, ylabel_flag,  mode_title, y_lims, outcome, flag_normalize_modes, plot_r_flag, key_trial_type, stim_legend_flag, k, xl,line_style,1);
set(gca,'Ytick',[0 y_lims(2)],'Xtick',[-2,0]);
text(xl(1)-diff(xl)*0.4, yl(1)+diff(yl)*1.25, 'B', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(-1.5,yl(2)*0.9,'Delay','FontSize',6);

% Choice mode
axes('position',[position_x2(2), position_y1(2), panel_width2, panel_height1]);
k=key;
k.mode_type_name = mode_names{1};
mode_title = mode_titles(1);
rel_Proj_current = rel_Proj & k;
y_lims = [-0.3,1];
xl=[-3.5,0];
[xl, yl] =figure_plotModes_correct_or_error (rel_Proj_current,  Param, xlabel_flag, title1, title2, title3, ylabel_flag,  mode_title, y_lims, outcome, flag_normalize_modes, plot_r_flag, key_trial_type, stim_legend_flag, k, xl,line_style,1);
set(gca,'Ytick',[0 y_lims(2)],'Xtick',[-2,0]);



% Ramping mode
axes('position',[position_x2(3), position_y1(2), panel_width2, panel_height1]);
k=key;
k.mode_type_name = mode_names{3};
mode_title = mode_titles(3);
rel_Proj_current = rel_Proj & k;
y_lims = [-0.1,1];
xl=[-3.5,0];
[xl, yl] =figure_plotModes_correct_or_error (rel_Proj_current,  Param, xlabel_flag, title1, title2, title3, ylabel_flag,  mode_title, y_lims, outcome, flag_normalize_modes, plot_r_flag, key_trial_type, stim_legend_flag, k, xl,line_style,1);
set(gca,'Ytick',[0 y_lims(2)],'Xtick',[-2,0]);



% Selectivity and Variance explained
[selectivity_explained,trialavg_var_explained, time2plot]= fn_compute_varaince(Param,rel_Proj,rel_PSTH, mode_names);

% %Selectivity explained
% axes('position',[position_x2(4), position_y1(2), panel_width2, panel_height1]);
% xl=fn_plot_variance(Param, time2plot, selectivity_explained);
% yl=[0 1];
% ylim(yl);
% set(gca, 'Ytick',ylim);
% text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.2, sprintf('Selectivity'),'HorizontalAlignment','center', 'FontSize',7, 'fontweight', 'bold');
% text(xl(1)-diff(xl)*0.18, yl(1)+diff(yl)*0.5, sprintf('Fraction \nexplained'),'HorizontalAlignment','center','Rotation',90, 'FontSize',7);
% 
% text(xl(1)+diff(xl)*-0.3, yl(1)+diff(yl)*1.2, 'C', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%'Trial-averaged Variance explained
axes('position',[position_x2(4), position_y1(2), panel_width2, panel_height1]);
xl=fn_plot_variance(Param, time2plot, trialavg_var_explained);
yl=[-0.05 0.6];
ylim(yl);
set(gca, 'Ytick',[0 0.6]);
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.2,  sprintf('Trial-averaged variance'),'HorizontalAlignment','center', 'FontSize',7);
text(xl(1)+diff(xl)*-0.25, yl(1)+diff(yl)*1.2, 'C', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.18, yl(1)+diff(yl)*0.5, sprintf('Fraction \nexplained'),'HorizontalAlignment','center','Rotation',90, 'FontSize',7);
    text(xl(1)+diff(xl)*0.5, yl(1)-diff(yl)*0.25,'Time to Go cue (s)', 'FontSize',7,'HorizontalAlignment','center');




if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
%

end




