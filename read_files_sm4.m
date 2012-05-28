clear 
filename = 'Hela_0001.SM4';
% filename = 'C:\Documents and Settings\martin\Desktop\TSpec_test_vidrio_0003.sm4';
info=read_sm4(filename);


%%
file_header = info{1}; % Total page count and object list count
object_list = info{2};
page_index_header = info{3};
page_index = info{4};
page_index_array = info{5};
page_header = info{6};
object_list_string = info{7};
string_data = info{8};
data = info{9};
% sequencial_data_page = info{9};
% data = info{10};

%% Plot 2 d data
for i=1:size(data,2)
    figure
    imagesc(data{i})
end


