function [xl,yl]=figure_plot_behav_regular_mini(behav_param, behav_param_mean, behav_param_signif,  x_r, x_l, y_r, y_l, trn_r, trn_l, flag_plot_left_right_trials, plot_signif_offset,names_right_trials, names_left_trials, legends)
hold on;


% Right trials
if (flag_plot_left_right_trials ==0 || flag_plot_left_right_trials ==2)
    set(gca, 'Xtick', [(-3.8), (-2.5), (-1.6), (-0.8),0], 'Ytick',[0 25 50], 'TickLabelInterpreter', 'None', 'FontSize', 6, 'XTickLabelRotation', 0);
    counter=0;
    for i=2:1:numel(trn_r)
        counter =counter+1;
        values =  [behav_param(trn_r(i)).values] - [behav_param(trn_r(1)).mean];
        values_stem = nanstd(values)/sqrt(numel(values));
        errorbar(x_r(counter),mean(values),  values_stem,'-', 'Color',legends.colr,'CapSize',4,'MarkerSize',6);
        v_mean(counter) = nanmean(values);
        text(x_r(counter)-0.025,v_mean(counter)+plot_signif_offset,behav_param_signif(trn_r(i)),'HorizontalAlignment','Center','FontSize',10,'FontWeight','bold','Color',legends.colr)
        yl=[-12 15];
    end
    plot(x_r,v_mean, '-','MarkerSize',6,'Color',legends.colr);
    
    
    plot([-3 -3],[-100 100],'-k','LineWidth',0.75);
    plot([-2.15 -2.15],[-100 100],'-k','LineWidth',0.75);
    plot([-100 100],[0 0],'--','LineWidth',0.75,'Color',[0.5 0.5 0.5]);
    
    xl=[-4 0];
    xlim(xl);
    ylim(yl);
    set(gca,'YTick',[-10 0 10]);
    text(xl(1)-diff(xl)*0.1 + legends.title_xoffset, yl(1)+diff(yl)*1.25+ legends.title_offset,sprintf('%s\n%s stimuli, right trials',legends.title_label,legends.stimuli_label),'FontSize',7,'Color',legends.colr,'HorizontalAlignment','left','fontweight','bold');
    presample_colr=fetch1(ANL.TrialTypeGraphic &  'trial_type_name="r_-3.8Full"','trialtype_rgb');
    text(-3.9, -5 ,sprintf('Pre-\nSample'),'FontSize',6,'HorizontalAlignment','left','Color',presample_colr);
    early_delay_colr=fetch1(ANL.TrialTypeGraphic &  'trial_type_name="r_-1.6Full"','trialtype_rgb');
    text(-2.1, -5 ,sprintf('Early\nDelay'),'FontSize',6,'HorizontalAlignment','left','Color',early_delay_colr);
    late_delay_colr=fetch1(ANL.TrialTypeGraphic &  'trial_type_name="r_-0.8Full"','trialtype_rgb');
    
end


% Left Trials
if (flag_plot_left_right_trials ==0 || flag_plot_left_right_trials ==1)
    set(gca, 'Xtick', [(-2.5), (-1.6), (-0.8),0], 'Ytick',[0 25 50], 'TickLabelInterpreter', 'None', 'FontSize', 6, 'XTickLabelRotation', 0);
    counter=0;
    for i=2:1:numel(trn_l)
        counter =counter+1;
        if exist('names_left_trials') && contains(names_left_trials(i),'r')
%             values =  [behav_param(trn_l(i)).values] - (100-(nanmean([behav_param(trn_l(1)).values])));
            values =  [behav_param(trn_l(i)).values] - (100-([behav_param(trn_l(1)).values]));
                                    values(isnan(values))=[];
            values_stem = nanstd(values)/sqrt(numel(values));
            errorbar(x_l(counter),nanmean(values),  values_stem,'-', 'Color',legends.colr,'CapSize',4,'MarkerSize',6);
            v_mean(counter) = nanmean(values);
            text(x_l(counter)+0.025,v_mean(counter)+plot_signif_offset,'***','HorizontalAlignment','Center','FontSize',10,'FontWeight','bold','Color',legends.colr)
            yl=[0 25];
            
        else
%             values = behav_param(trn_l(1)).mean - [behav_param(trn_l(i)).values];
            values =  [100-behav_param(trn_l(i)).values] - [100-behav_param(trn_l(1)).values];
                                    values(isnan(values))=[];
            values_stem = nanstd(values)/sqrt(numel(values));
            errorbar(x_l(counter),nanmean(values),  values_stem,'-', 'Color',legends.colr,'CapSize',4,'MarkerSize',6);
            v_mean(counter) = nanmean(values);
            text(x_l(counter)+0.025,v_mean(counter)+plot_signif_offset,behav_param_signif(trn_l(i)),'HorizontalAlignment','Center','FontSize',10,'FontWeight','bold','Color',legends.colr)
            yl=[0 25];
        end
    end
    plot(x_l,v_mean, '-','MarkerSize',6,'Color',legends.colr,'Clipping','off');
    
    % plot([-3 -3],[-100 100],'--k','LineWidth',0.75);
    plot([-2.15 -2.15],[-100 100],'-k','LineWidth',0.75);
    % plot([0 0],[-100 100],'--k','LineWidth',0.75);
    
    xl=[-3 0];
    xlim(xl);
    ylim(yl);
    set(gca,'YTick',[0 25]);
   
%     text(-2.5, 35*0.7 ,sprintf('Sample'),'FontSize',6,'HorizontalAlignment','left','Color',[1 0 1],'Rotation',90);
%     early_delay_colr=fetch1(ANL.TrialTypeGraphic &  'trial_type_name="l_-1.6Full"','trialtype_rgb');
%     text(-1.8, 50*0.7 ,sprintf('Early\nDelay'),'FontSize',6,'HorizontalAlignment','left','Color',early_delay_colr);
%     late_delay_colr=fetch1(ANL.TrialTypeGraphic &  'trial_type_name="l_-0.8Full"','trialtype_rgb');
%     text(-0.95, 25*0.7 ,sprintf('Late \nDelay'),'FontSize',6,'HorizontalAlignment','left','Color',late_delay_colr);
    
    
end

%      text(xl(1)+diff(xl)*0.5 + legends.title_xoffset, yl(1)+diff(yl)*1.75,sprintf('Response to photostimulation\nat different times'),'FontSize',7,'Color',[0 0 0],'HorizontalAlignment','center','fontweight','bold');

    text(-3.75,yl(1)+diff(yl)/2,sprintf('\\Delta response\n lick right (%%)'),'FontSize',7,'Rotation',90,'HorizontalAlignment','center');

 text(xl(1)+diff(xl)*1.15 + legends.title_xoffset, yl(1)+diff(yl)*-0.25,sprintf('%s mice',legends.title_label),'FontSize',7,'Color',legends.colr,'HorizontalAlignment','center','Rotation',90);
 text(xl(1)+diff(xl)*1.3 + legends.title_xoffset, yl(1)+diff(yl)*-0.25,sprintf('Distractor-trained mice'),'FontSize',7,'Color',[0.5 0 0.5],'HorizontalAlignment','center','Rotation',90);

% factor=20;
% % Plot waves - mini stimuli
% x = 0:0.01:pi;
% plot(linspace(-2.5,-2.4,numel(x)),sin(x)*(factor/3)+74,'Color',[0.6 0.85 1],'LineWidth',1,'Clipping','off')
% plot(linspace(-1.6,-1.5,numel(x)),sin(x)*(factor/3)+74,'Color',[0.6 0.85 1],'LineWidth',1,'Clipping','off')
% plot(linspace(-0.8,-0.7,numel(x)),sin(x)*(factor/3)+74,'Color',[0.6 0.85 1],'LineWidth',1,'Clipping','off')
% text(xl(1)+diff(xl)*0.7, yl(1)+diff(yl)*1.7, 'mini', 'fontsize', 7');
% plot(linspace(-0.3,-0.4,numel(x)),sin(x)*(factor/3)+110,'Color',[0.6 0.85 1],'LineWidth',1,'Clipping','off')

    text(xl(1)+diff(xl)*0.5, yl(1)-diff(yl)*0.3,'Time to Go cue (s)', 'FontSize',7,'HorizontalAlignment','center');

box off;