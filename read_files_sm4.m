% 
% This script uses the function read_sm4.m to read the binary data saved
% with the RHK format sm4 (saved in the program XMPro 2.0)
%
% It is an example of use of the mentioned function.
% It plots the data obtained.
%
% Created by: M. Caldarola (caldarola@df.uba.ar)
%
% See git repository for the date of the changes. 
% 
%%%%%%%%%%%%%%%%%%%%%%%%

clear 
filename = '/home/martin/lec/phd/programas/matlab/read_sm4/devel_files/TGZ03_0001.SM4';
% filename = '/home/martin/lec/phd/programas/matlab/read_sm4/devel_files/Hela_0001.SM4';
% filename = '/home/martin/lec/phd/programas/matlab/read_sm4/devel_files/TSpec_test_vidrio_0003.SM4';
% filename = '/home/martin/lec/phd/programas/matlab/read_sm4/devel_files/C_M_lito_fluo_rojo_0004.sm4';
% filename = 'E:\Martin\phd\programas\matlab\read_sm4\devel_files\TSpec_test_vidrio_0003.sm4';
[data metadata]=read_sm4(filename);

%% select if the data is spectroscopy or image, in order to plot
%% conviniently.

IMA = 'T'; % TRUE means that it is an image
% IMA = 'False'; % FALSE means that is not an image, just force curves


if IMA == 'F'
    % PLOTS only for spectroscopy data
    for i = 1:size(data,2);
        figure
        plot(data{i}.x,data{i}.z)
        title([metadata{i}.string_data.Label,' [',...
            metadata{i}.string_data.Z_Units,']'],'FontSize',20)
        xlabel(metadata{i}.string_data.X_Units,'FontSize',16) % x units
        % in spectroscopy, y is empty
        ylabel(metadata{i}.string_data.Z_Units,'FontSize',16) % z units
        grid
    end
    
    % Plot ALL 2 d data, images
else
    for i=1:size(data,2)
        figure
        imagesc([data{i}.x(1),data{i}.x(end)],[data{i}.y(1),data{i}.y(end)],...
            data{i}.z)
        colorbar
        colormap(gray)
        title([metadata{i}.string_data.Label,' [',metadata{i}.string_data.Z_Units,']'],'FontSize',20)
        xlabel(metadata{i}.string_data.X_Units,'FontSize',16)
        ylabel(metadata{i}.string_data.Y_Units,'FontSize',16)
        
    end
    % Take a profile
    
    figure
    plot(data{end}.y,data{end}.z(:,100))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%