clear 
% filename = 'TGZ03_0001.SM4';
% filename = 'Hela_0001.SM4';
filename = 'TSpec_test_vidrio_0003.SM4';
info=read_sm4(filename);


%%
% file_header = info{1}; % Total page count and object list count
% object_list = info{2};
% page_index_header = info{3};
% page_index = info{4};
% page_index_array = info{5};
% page_header = info{6};
% object_list_string = info{7};
% string_data = info{8};
% data = info{9};
% metadata = info{10};

data = info{1}; metadata = info{2};


%% only for spectroscopy data

% plot data
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
%% only for images
% Plot ALL 2 d data 
% for i=1:size(data,2)
%     figure
%     imagesc([data{i}.x(1),data{i}.x(end)],[data{i}.y(1),data{i}.y(end)],...
%             data{i}.z)
%     colorbar
%     colormap(gray)
%     title([string_data(i).strings{1,2},' [',string_data(i).strings{10,2},']'],'FontSize',20)
%     xlabel(string_data(i).strings{8,2},'FontSize',16)
%     ylabel(string_data(i).strings{9,2},'FontSize',16)
%     
% end
% % Take a profile
%     
% figure
% plot(data{end}.y,data{end}.z(:,100))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%