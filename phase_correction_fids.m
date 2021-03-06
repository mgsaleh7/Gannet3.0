function out = phase_correction_fids(MRS_struct,data,water_data)

% Written and updated by MGSaleh, University of Cape Town & The Johns Hopkins University School of Medicine, 2016.
% The function subtracts the phase of the unsuppressed (water_data) data
% from the phase of the suppressed data.

K=abs(water_data(1,:));  % Only takes the first coloumn of data if water data are not averaged  -- MGSaleh
Kphase=phase(water_data(1,:));

sz_mat=size(data);
fids=zeros(sz_mat);


% figure,plot(real(fftshift(fft(data.'))))
% xlim([1100 1400])
% title('Before eddy current correction')



for kk=1:sz_mat(1)


    K_data=abs(data(kk,:));
    Kphase_data=phase(data(kk,:));
    
    Kphase_corr=(Kphase_data)-Kphase;
    
    fids(kk,:)=K_data.* exp(1i*Kphase_corr);
    

end

% figure,plot(real(fftshift(fft(fids.'))))
% xlim([1100 1400])
% title('After eddy current correction')

out = fids;




