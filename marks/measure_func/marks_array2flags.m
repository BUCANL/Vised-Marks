% This function takes an array typically created by chan_variance or
% chan_neighbour_r and marks either periods of time or sources as outliers.
% Often these discovered time periods are artefactual and are  marked as such.
%
% An array of values representating the distribution of values inside an
% epoch are passed to the function. Next, these values are put through one
% of three outlier detection schemes. Epochs that are outliers are marked
% as 1's and are 0 otherwise in a second data array. This array is then
% averaged column-wise or row-wise. Column-wise averaging results in
% flagging of time, while row-wise results in rejection of sources. This
% averaged distribution is put through another round of outlier detection.
% This time, if data points are outliers, they are flagged.
% 
% Output:
% outarray - Mask of periods of time that are flagged as outliers
% outind   - Array of 1's and 0's. 1's represent flagged sources/time. 
%            Indices are only flagged if out_dist array fall above a second
%            outlier threshhold.
% out_dist - Distribution of rejection array. Either the mean row-wise or
%            column-wise of outarray.
%
% Input:
% inarray - Data array created by eiether chan_variance or chan_neighbour_r
% 
% Varargs:
% init_dir     - String; one of: 'pos', 'neg', 'both'. Allows looking for
%                unusually low (neg) correlations, high (pos) or both.
% flag_dim     - String; one of: 'col', 'row'. Col flags time, row flags 
%                sources.
% init_method  - String; one of: 'q', 'z', 'fixed'. See method section. 
% init_vals    - See method section.
% init_crit    - See method section.
% flag_method  - String; one of: 'q', 'z', 'fixed'. See method section.
%                Second pass responsible for flagging aggregate array.
% flag_vals    - See method section. Second pass for flagging.
% flag_crit    - See method section. Second pass for flagging.
% plot_figs    - String; one of: 'on', 'off'.
% title_prefix - String prefix to add to each figure.
% trim         - Numerical value of trimmed mean and std. Only valid for z.
%
% Methods:
% fixed - This method does no investigation if the distribution. Instead
%         specific criteria are given via vals and crit. If fixed
%         is selected for the init_method option, only init_vals should be
%         filled while init_crit is to be left empty. This would have the
%         effect of marking some interval, e.g. [0 50] as being an outlier.
%         If fixed is selected for flag_method, only flag_crit should be
%         filled. This translates to a threshhold that something must pass
%         to be flagged. i.e. if 0.2 (20%) of channels are behaving as
%         outliers, then the period of time is flagged. Conversely if
%         flag_dim is row, if a source is bad 20% of the time it is marked
%         as a bad channel.
% 
% q     - Quantile method. init_vals allows for the specification of which
%         quantiles to use, e.g. [.3 .7]. When using flag_vals only specify
%         one quantile, e.g [.7]. The absolute difference between the
%         median and these quantiles returns a distance. init_crit and
%         flag_crit scales this distance. If values are found to be outside
%         of this, they are flagged.
% 
% z     - Typical Z score calculation for distance. Vals and crit options
%         not used for this methodology. See trim option above for control.

function [outarray,outind,out_dist]=marks_array2flags(inarray,varargin)

%% handle varargin
g=struct(varargin{:});

try g.flag_dim; catch, g.flag_dim='row'; end; %row = return column of row flags, col = return row of column flags

try g.init_method; catch, g.init_method='q'; end; %q = quantile outlier classification, z = zscore outlier classification, fixed = outlier cutoffs.
try g.init_vals; catch, g.init_vals=[]; end; %distribution values for flagging by flag_crit = 'q' or 'fixed'

try g.init_dir; catch, g.init_dir='both'; end; %pos, neg, both
try g.init_crit; catch, g.init_crit=[]; end; %outlier distance classification

try g.flag_method; catch, g.flag_method='z_score'; end; %fixed, dist
try g.flag_vals; catch, g.flag_vals=[]; end; %distribution values for flagging by flag_crit = 'q' or 'fixed'

% flag_val is deprecated... trated synonymous with flag_crit for
% flag_method "z_score" and "fixed".
try 
	g.flag_val;
	g.flag_crit = g.flag_val;
	disp('WARNING: flag_val is now depcrecated. Please see documentation and use flag_crit.');
catch, 
	% g.flag_val=[];
	% g.flag_crit = [];	
	disp('WARNING: flag_val is now depcrecated. Please see documentation and use flag_crit.');
end; % value of percentage

try g.flag_crit; catch, g.flag_crit=[]; end; % value of percentage

try g.trim; catch, g.trim=0; end;
try g.plot_figs; catch, g.plot_figs='off';end;

try g.title_prefix; catch, g.title_prefix='';end;

%% if flagdir is column wise rotate the inarray.
if strcmp(g.flag_dim,'col');
    inarray=inarray';
end

%% return flags indices (outind) from input measure (inarray) 

%allocate output variables
outarray=zeros(size(inarray));
outind=1:size(inarray,2);

m_dist=[];
s_dist=[];
l_dist=[];
u_dist=[];
l_out=[];
u_out=[];

% for each column flag cell of inarray
for coli=outind;
    %Calculate mean and standard deviation for each column
    switch g.init_method
        case 'q'
            switch length(g.init_vals)
                case 1
                    qval(1)=.5-g.init_vals;
                    qval(2)=.5;
                    qval(3)=.5+g.init_vals;                    
                case 2
                    qval(1)=g.init_vals(1);
                    qval(2)=.5;
                    qval(3)=g.init_vals(2);                                        
                case 3
                    qval(1)=g.init_vals(1);
                    qval(2)=g.init_vals(2);
                    qval(3)=g.init_vals(3);
            end
            m_dist(coli)=quantile(inarray(:,coli),qval(2));
            %s_dist(coli)=ve_trimstd(inarray(:,coli),g.trim);
            l_dist(coli)=quantile(inarray(:,coli),qval(1));
            u_dist(coli)=quantile(inarray(:,coli),qval(3));
            l_out(coli)=m_dist(coli)-(m_dist(coli)-l_dist(coli))*g.init_crit;
            u_out(coli)=m_dist(coli)+(u_dist(coli)-m_dist(coli))*g.init_crit;
        case 'z'
            m_dist(coli)=ve_trimmean(inarray(:,coli),g.trim);
            s_dist(coli)=ve_trimstd(inarray(:,coli),g.trim);
            l_dist(coli)=m_dist(coli)-s_dist(coli);
            u_dist(coli)=m_dist(coli)+s_dist(coli);
            l_out(coli)=m_dist(coli)-s_dist(coli)*g.init_crit;
            u_out(coli)=m_dist(coli)+s_dist(coli)*g.init_crit;
        case 'fixed'
            l_out(coli)=g.init_vals(1);
            u_out(coli)=g.init_vals(2);
    end
    
    %for each row
    for rowi=1:size(inarray,1);
        %flag outlying values
        if strcmp(g.init_dir,'pos')||strcmp(g.init_dir,'both');
            %for positive outliers
            if inarray(rowi,coli)>u_out(coli);
                outarray(rowi,coli)=1;
            end
        end
        if strcmp(g.init_dir,'neg')||strcmp(g.init_dir,'both');
            %for negative outliers
            if inarray(rowi,coli)<l_out(coli);
                outarray(rowi,coli)=1;
            end
        end
    end
end

%average column of outarray
critrow=squeeze(mean(outarray,2));

%set the flag index threshold (may add quantile option here as well)
switch (g.flag_method);
    case 'fixed';
        rowthresh=g.flag_crit;
    case 'z_score'
        mccritrow=mean(critrow);
        sccritrow=std(critrow);        
        rowthresh=mccritrow+sccritrow*g.flag_crit;
    case 'q';
        qval=[];
        qval(1)=.5;
        qval(2)=g.flag_vals;
        mccritrow=quantile(critrow,qval(1));
        sccritrow=quantile(critrow,qval(2));
        rowthresh=mccritrow+(sccritrow-mccritrow)*g.flag_crit;
end

%get indeces of rows beyond threshold
outind=find(critrow>rowthresh);

%% if flagdir is column wise rotate the outarray and ouind.
if strcmp(g.flag_dim,'col');
    inarray=inarray';
    outarray=outarray';
    outind=outind';
end




%% plots
if strcmp(g.plot_figs,'on')
    
    if strcmp(g.flag_dim,'row')        
        figure;
        surf(double(inarray),'LineStyle','none');
        colorbar('WestOutside');
        axis('tight');
        view(0,90);
        title([g.title_prefix,'raw input array']);

        figure;
        scatter(1:length(m_dist),m_dist,20,...
            'MarkerEdgeColor',[.3 .3 .3],...
            'MarkerFaceColor',[.3 .3 .3]);
        hold on;
        for i=1:size(outarray,2);
            outvals=[];
            outvals=inarray(find(outarray(:,i)),i);
            scatter(ones(size(outvals))*i,outvals,20,'r+');
        end
        scatter(1:length(l_dist),l_dist,20,...
            'MarkerEdgeColor',[.65 .65 .65],...
            'MarkerFaceColor',[.65 .65 .65]);
        scatter(1:length(u_dist),u_dist,20,...
            'MarkerEdgeColor',[.65 .65 .65],...
            'MarkerFaceColor',[.65 .65 .65]);
        scatter(1:length(l_out),l_out,20,...
            'MarkerEdgeColor',[.3 .3 .7],...
            'MarkerFaceColor',[.3 .3 .7]);
        scatter(1:length(u_out),u_out,20,...
            'MarkerEdgeColor',[.3 .3 .7],...
            'MarkerFaceColor',[.3 .3 .7]);
        axis('tight');
        title([g.title_prefix,'initial distributions with outliers']);

        figure;
        %subplot(1,3,[1,2]);
        surf(outarray,'LineStyle','none');
        colorbar('WestOutside');
        axis('tight');
        view(0,90);
        title([g.title_prefix,'initial array of flagged outliers']);
        
        %subplot(1,3,[3]);
        figure;
        plot(critrow);
        hold on;plot(ones(size(critrow))*rowthresh,'r');
        axis('tight');
        view(90,270)
        title([g.title_prefix,'cutoff values']);

    else
        figure;
        surf(double(inarray),'LineStyle','none');
        colorbar('WestOutside');
        axis('tight');
        view(0,90);
        title([g.title_prefix,'raw input array']);
        
        figure;
        scatter(1:length(m_dist),m_dist,20,...
            'MarkerEdgeColor',[.3 .3 .3],...
            'MarkerFaceColor',[.3 .3 .3]);
        hold on;
        for i=1:size(outarray,1);
            outvals=[];
            outvals=inarray(i,find(outarray(i,:)));
            scatter(ones(size(outvals))*i,outvals,20,'r+');
        end
        scatter(1:length(l_dist),l_dist,20,...
            'MarkerEdgeColor',[.65 .65 .65],...
            'MarkerFaceColor',[.65 .65 .65]);
        scatter(1:length(u_dist),u_dist,20,...
            'MarkerEdgeColor',[.65 .65 .65],...
            'MarkerFaceColor',[.65 .65 .65]);
        scatter(1:length(l_out),l_out,20,...
            'MarkerEdgeColor',[.3 .3 .7],...
            'MarkerFaceColor',[.3 .3 .7]);
        scatter(1:length(u_out),u_out,20,...
            'MarkerEdgeColor',[.3 .3 .7],...
            'MarkerFaceColor',[.3 .3 .7]);
        axis('tight');
        view(90,270)
        title([g.title_prefix,'initial distributions with outliers']);
        
        figure;
        %subplot(3,1,[1,2]);
        surf(outarray,'LineStyle','none');
        axis('tight');
        view(0,90);
        title([g.title_prefix,'initial array of flagged outliers']);
        
        %subplot(3,1,[3]);
        figure;
        plot(critrow);
        hold on;plot(ones(size(critrow))*rowthresh,'r');
        axis('tight');
        title([g.title_prefix,'cutoff values']);
    end
end

out_dist=[m_dist;l_dist;u_dist;l_out;u_out];
