clear 
filename = 'Hela_0001.SM4';
% filename = 'C:\Documents and Settings\martin\Desktop\TSpec_test_vidrio_0003.sm4';
data=read_sm4(filename);


%%
file_header=data{1}; % Total page count and object list count
object_list=data{2};
page_index_header=data{3};
page_index=data{4};
page_index_array=data{5};
page_header=data{6};
object_list_string=data{7};


%%

object_list_string(end)




