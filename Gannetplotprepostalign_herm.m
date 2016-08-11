function Gannetplotprepostalign_herm(MRS_struct, specno)
%function MRSplotprepostalign(MRS_struct, specno)
% Plots pre and post alignment spectra in MRSLoadPfiles
% 110214:  Scale spectra by the peak _height_ of water
%          Plot multiple spectra as a stack - baselines offset
%            by mean height of GABA

numspec = 4;

     
    
SpectraToPlot = [eval(['MRS_struct.spec.', sprintf('%s',MRS_struct.p.target2),'.diff']); ...
                 eval(['MRS_struct.spec.', sprintf('%s',MRS_struct.p.target2),'.diff_noalign']); ...
                 eval(['MRS_struct.spec.', sprintf('%s',MRS_struct.p.target),'.diff']); ...
                 eval(['MRS_struct.spec.', sprintf('%s',MRS_struct.p.target),'.diff_noalign']);];








% SpectraToPlot = [MRS_struct.spec.diff(specno,:); MRS_struct.spec.diff_noalign(specno,:)];


% Estimate baseline from between Glx and GABA
z=abs(MRS_struct.spec.freq-3.6);
Glx_right=find(min(z)==z);
z=abs(MRS_struct.spec.freq-3.3);
GABA_left=find(min(z)==z);
z=abs(MRS_struct.spec.freq-2.8);
GABA_right=find(min(z)==z);;
specbaseline = (mean(real(SpectraToPlot(1,Glx_right:GABA_left)),2));


% averaged gaba height across all scans - to estimate stack spacing
gabaheight = abs(max(SpectraToPlot(1,Glx_right:GABA_right),[],2));
gabaheight = mean(gabaheight);
plotstackoffset = [ 0 : (numspec-1) ]';
plotstackoffset = plotstackoffset * gabaheight;
plotstackoffset = plotstackoffset - specbaseline;

% Added by MGSaleh 2016
plot(MRS_struct.spec.freq, real(SpectraToPlot((1:2),:)));
hold on 
shft=repmat(plotstackoffset, [1 length(SpectraToPlot(1,:))]);
size(shft)
SpectraToPlot(3:4,:) = SpectraToPlot(3:4,:) + [max(shft,[],1); max(shft,[],1)] ;
plot(MRS_struct.spec.freq, real(SpectraToPlot((3:4),:)));
hold off


legendtxt = {'post', 'pre'};
hl=legend(legendtxt);
set(hl,'EdgeColor',[1 1 1]);
set(gca,'XDir','reverse');
oldaxis = axis;
yaxismax = (numspec + 2) *gabaheight; % top spec + 2* height of gaba
yaxismin =  - 2* gabaheight; % extend 2* gaba heights below zero
if (yaxismax<yaxismin)
    dummy=yaxismin;
    yaxismin=yaxismax;
    yaxismax=dummy;
end
% yaxismax
% yaxismin
axis([0 5  yaxismin yaxismax])