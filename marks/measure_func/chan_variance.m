% This function creates data arrays from an epoched EEG structure to eventually
% be flagged by the marks_array2flags function.
% Output:
% EEG - EEG Structure
% data_sd - Data array for further processing
% Input:
% EEG - Standard EEG structure
% 'datafield'  - If 'data' is pair, output array is created with EEG data. 
%                Otherwise, it is created via ICA data
% 'epoch_inds' - Array of 1's and 0's marking epochs to consider. Typically
%                this array is created via marks_label2index.
% 'plot_figs'  - String; one of: 'on', 'off'. Default off.
% 'varmeasure' - String; one of: 'sd', 'absmean', 'spect'. Methodology for
%                value that will represent the epoch.
% 'detrending' - String; one of: 'on', 'off'. Detrend epochs.
% 'spectrange' - Array of double, length 2. e.g. [0 7].
%                Only valid for varmeasure spect.
function [EEG,data_sd]=chan_variance(EEG,varargin)

g=struct(varargin{:});

try g.data_field; catch, g.data_field='data'; end;
if strcmp(g.data_field,'data');
    try g.chan_inds;    catch, g.chan_inds=1:EEG.nbchan; end;
else
    try g.chan_inds;    catch, g.chan_inds=1:size(EEG.icawinv,2); end;
end
try g.epoch_inds;   catch, g.epoch_inds=1:EEG.pnts; end;
try g.plot_figs;  catch, g.plot_figs='off'; end;
try g.varmeasure;  catch, g.varmeasure='sd'; end;
try g.detrend;  catch, g.detrend='off'; end;
try g.spectrange; catch, g.spectrange=[]; end;

if strcmp(g.data_field,'icaact') && isempty(EEG.icaact);
    for i=1:EEG.trials;
        tmpdata(:,:,i)=(EEG.icaweights*EEG.icasphere)*(EEG.data(EEG.icachansind,:,i));
    end
    data=tmpdata(g.chan_inds,:,g.epoch_inds);
else
    eval(['data=EEG.',g.data_field,'(g.chan_inds,:,g.epoch_inds);']);
end

if strcmp(g.detrend,'on');
    for i=1:length(g.epoch_inds);
        tmp=detrend(squeeze(data(:,:,i))');
        data(:,:,i)=tmp';
    end
end


switch g.varmeasure
    case 'sd'
        data_sd=squeeze(std(data,[],2));

    case 'absmean'
        data_sd=squeeze(mean(abs(data),2));

    case 'spect'
        p=abs(fft(bsxfun(@times,data,hanning(EEG.pnts)'),[],2));
        fstep=EEG.srate/EEG.pnts;
        f=[fstep:fstep:EEG.srate]-fstep;
        [val,ind(1)]=min(abs(f-(g.spectrange(1))));
        [val,ind(2)]=min(abs(f-(g.spectrange(2))));
        data_sd=squeeze(mean(p(:,ind(1):ind(2),:),2));
end

if strcmp(g.plot_figs,'on');
    figure;surf(double(data_sd),'LineStyle','none');
    axis('tight');
    view(0,90);
end