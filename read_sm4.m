function info=read_sm4(filename)
% This functions is designed to read the binary data of the .sm4 files,
% produced by the XMpro software (RHK technology Inc.)
%
%
% Created by: M. Caldarola (caldarola@df.uba.ar)
%   Author's comment: I want to thank H. Grecco for his help in this
%                     matter.
% May 2012
%%%%%%%%%%%%%%%%%%%%%%%%

%% DEFINITIONS FROM THE MANUAL
% Object Type
% Image Type
% Line Type
% source imgae type
% image type
% scan direction

%% object type
object_type(1).code = 0:17;
object_type(1).code(19) =  -42;   % file header code
object_type(1).code(20) =  -43;   % file header code

object_type(1).name = 'RHK_OBJECT_UNDEFINED';          
object_type(2).name = 'RHK_OBJECT_PAGE_INDEX_HEADER';  
object_type(3).name = 'RHK_OBJECT_PAGE_INDEX_ARRAY';  
object_type(4).name = 'RHK_OBJECT_PAGE_HEADER';
object_type(5).name = 'RHK_OBJECT_PAGE_DATA';
object_type(6).name = 'RHK_OBJECT_IMAGE_DRIFT_HEADER';
object_type(7).name = 'RHK_OBJECT_IMAGE_DRIFT';
object_type(8).name = 'RHK_OBJECT_SPEC_DRIFT_HEADER';
object_type(9).name = 'RHK_OBJECT_SPEC_DRIFT_DATA';
object_type(10).name = 'RHK_OBJECT_COLOR_INFO';
object_type(11).name = 'RHK_OBJECT_STRING_DATA';
object_type(12).name = 'RHK_OBJECT_TIP_TRACK_HEADER';
object_type(13).name = 'RHK_OBJECT_TIP_TRACK_DATA';
object_type(14).name = 'RHK_OBJECT_PRM';
object_type(15).name = 'RHK_OBJECT_THUMBNAIL';
object_type(16).name = 'RHK_OBJECT_PRM_HEADER';
object_type(17).name = 'RHK_OBJECT_THUMBNAIL_HEADER';
object_type(18).name = 'RHK_OBJECT_API_INFO';
%/* Our types */
object_type(19).name = 'RHK_OBJECT_FILE_HEADER';
object_type(20).name= 'RHK_OBJECT_PAGE_INDEX';

%% image type
image_type(1).code = 0:39;
image_type(1).name = 'RHK_PAGE_UNDEFINED';  % = 0,
image_type(2).name = 'RHK_PAGE_TOPOGAPHIC'; % = 1,
image_type(3).name = 'RHK_PAGE_CURRENT';    % = 2,
image_type(4).name = 'RHK_PAGE_AUX';        % = 3,
image_type(5).name = 'RHK_PAGE_FORCE';      % = 4,
image_type(6).name = 'RHK_PAGE_SIGNAL'      % = 5,
image_type(7).name = 'RHK_PAGE_FFT';        % = 6,
image_type(8).name = 'RHK_PAGE_NOISE_POWER_SPECTRUM';   % = 7,
image_type(9).name = 'RHK_PAGE_LINE_TEST';              % = 8,
image_type(10).name = 'RHK_PAGE_OSCILLOSCOPE';           % = 9,
image_type(11).name = 'RHK_PAGE_IV_SPECTRA';             % = 10,
image_type(12).name = 'RHK_PAGE_IV_4x4';                 % = 11,
image_type(13).name = 'RHK_PAGE_IV_8x8';                 % = 12,
image_type(14).name = 'RHK_PAGE_IV_16x16';               % = 13,
image_type(15).name = 'RHK_PAGE_IV_32x32';               % = 14,
image_type(16).name = 'RHK_PAGE_IV_CENTER';              % = 15,
image_type(17).name = 'RHK_PAGE_INTERACTIVE_SPECTRA';    % = 16,
image_type(18).name = 'RHK_PAGE_AUTOCORRELATION';        % = 17,
image_type(19).name = 'RHK_PAGE_IZ_SPECTRA';             % = 18,
image_type(20).name = 'RHK_PAGE_4_GAIN_TOPOGRAPHY';      % = 19,
image_type(21).name = 'RHK_PAGE_8_GAIN_TOPOGRAPHY';      % = 20,
image_type(22).name = 'RHK_PAGE_4_GAIN_CURRENT';         % = 21,
image_type(23).name = 'RHK_PAGE_8_GAIN_CURRENT';         % = 22,
image_type(24).name = 'RHK_PAGE_IV_64x64';               % = 23,
image_type(25).name = 'RHK_PAGE_AUTOCORRELATION_SPECTRUM';% = 24,
image_type(26).name = 'RHK_PAGE_COUNTER';                % = 25,
image_type(27).name = 'RHK_PAGE_MULTICHANNEL_ANALYSER';  % = 26,
image_type(28).name = 'RHK_PAGE_AFM_100';                % = 27,
image_type(29).name = 'RHK_PAGE_CITS';                   % = 28,
image_type(30).name = 'RHK_PAGE_GPIB';                   % = 29,
image_type(31).name = 'RHK_PAGE_VIDEO_CHANNEL';          % = 30,
image_type(32).name = 'RHK_PAGE_IMAGE_OUT_SPECTRA';      % = 31,
image_type(33).name = 'RHK_PAGE_I_DATALOG';              % = 32,
image_type(34).name = 'RHK_PAGE_I_ECSET';                % = 33,
image_type(35).name = 'RHK_PAGE_I_ECDATA';               % = 34,
image_type(36).name = 'RHK_PAGE_I_DSP_AD';               % = 35,
image_type(37).name = 'RHK_PAGE_DISCRETE_SPECTROSCOPY_PP';% = 36,
image_type(38).name = 'RHK_PAGE_IMAGE_DISCRETE_SPECTROSCOPY'; % = 37,
image_type(39).name = 'RHK_PAGE_RAMP_SPECTROSCOPY_RP';        % = 38,
image_type(40).name = 'RHK_PAGE_DISCRETE_SPECTROSCOPY_RP';    % = 39,


%% line type
line_type(1).code = 0:22;
line_type(1).name = 'RHK_LINE_NOT_A_LINE';      % = 0,
line_type(2).name = 'RHK_LINE_HISTOGRAM';       % = 1,
line_type(3).name = 'RHK_LINE_CROSS_SECTION';   % = 2,
line_type(4).name = 'RHK_LINE_LINE_TEST';       % = 3,
line_type(5).name = 'RHK_LINE_OSCILLOSCOPE';    % = 4,
line_type(6).name = 'RHK_LINE_NOISE_POWER_SPECTRUM';    % = 6,
line_type(7).name = 'RHK_LINE_IV_SPECTRUM';             % = 7,
line_type(8).name = 'RHK_LINE_IZ_SPECTRUM';             % = 8,
line_type(9).name = 'RHK_LINE_IMAGE_X_AVERAGE';         % = 9,
line_type(10).name = 'RHK_LINE_IMAGE_Y_AVERAGE';         % = 10,
line_type(12).name = 'RHK_LINE_NOISE_AUTOCORRELATION_SPECTRUM';  % = 11,
line_type(13).name = 'RHK_LINE_MULTICHANNEL_ANALYSER_DATA';      % = 12,
line_type(14).name = 'RHK_LINE_RENORMALIZED_IV';                 % = 13,
line_type(15).name = 'RHK_LINE_IMAGE_HISTOGRAM_SPECTRA';         % = 14,
line_type(16).name = 'RHK_LINE_IMAGE_CROSS_SECTION';             % = 15,
line_type(17).name = 'RHK_LINE_IMAGE_AVERAGE';                   % = 16,
line_type(18).name = 'RHK_LINE_IMAGE_CROSS_SECTION_G';           % = 17,
line_type(19).name = 'RHK_LINE_IMAGE_OUT_SPECTRA';               % = 18,
line_type(20).name = 'RHK_LINE_DATALOG_SPECTRUM';                % = 19,
line_type(21).name = 'RHK_LINE_GXY';                             % = 20,
line_type(22).name = 'RHK_LINE_ELECTROCHEMISTRY';                % = 21,
line_type(23).name = 'RHK_LINE_DISCRETE_SPECTROSCOPY';           % = 22,

%% source imgae type
source_image(1).code = 0:3;
source_image(1).name = 'RHK_SOURCE_RAW';         % = 0,
source_image(2).name = 'RHK_SOURCE_PROCESSED';   % = 1,
source_image(3).name = 'RHK_SOURCE_CALCULATED';  % = 2,
source_image(4).name = 'RHK_SOURCE_IMPORTED';    % = 3,
%% image type
image_type2(1).code = [0 1];
image_type2(1).name = 'RHK_IMAGE_NORMAL';           % = 0,
image_type2(2).name = 'RHK_IMAGE_AUTOCORRELATED';   % = 1,

%% scan direction
scan_dir(1).code = 0:3; 
scan_dir(1).name = 'RHK_SCAN_RIGHT';        % = 0,
scan_dir(2).name = 'RHK_SCAN_LEFT';         % = 1,
scan_dir(3).name = 'RHK_SCAN_UP';           % = 2,
scan_dir(4).name = 'RHK_SCAN_DOWN';         % = 3,

%% open the file
fid = fopen(filename, 'r');

%% read the file header
file_header = read_file_header();          % file header
% the file header contains 
%       header size: the size for the actual header
%       signature: STiMage 004.000 1
%                      mayor version. minor version Unicode=1
%       total page count: the basic structure is a page, where data is
%                         saved
%       object_list_count: the count of objects that comes after the file
%                          header
%       object_field_size: size of the following object (4 for each struct)
%       reserved: bytes reserved for future use.

%% read the objet list: Says what is in the file and where it is located
for i=1:file_header.object_list_count
    object_list(i) = read_objects();
end

%% Read the page index header
% says the number of pages enlisted in the page index array
page_index_header = read_page_index_header(); 
%% get the page index array
object = read_objects(); % says that the structure we are reading is "page index array"

%% this reads the page index array
% it is an array of (page_count X 4) because for each page we have 4
% structures to read: (PageHeader) (PageData) (Thumbnail) (ThumnailHeader)

for j=1:page_index_header.page_count; % this for reads the page index array for each page
    page_index(j) = read_page_index();
    for i=1: page_index(j).object_list_count % this for reads the objects in each column
        aux(i) = read_objects();
    end
    page_index_array(j,:)=aux; % this builds an array of (N x4) where N is the numbers of pages in the file
end
clear aux

%% read page header: use the data in page_idex_array
% this for runs over the page count and reads the page_header, the 
% object_list_string and the string_data for each page
% with this information the data can be acceced and understood.
for j = 1:page_index_header.page_count
    fseek(fid,page_index_array(j,1).offset-1,'bof'); % seek for the position where the page header is
    page_header(j) = read_page_header(); % read the page header with the function defined later in this file
    
    % after the page_header there is another object list (8 objects)
    fseek(fid,4,0); % skip 4 bytes (unexplainable, yet)
    for i=1:9
        object_list_string(j,i) = read_objects();
    end
    % read string data
    string_data(j) = read_string_data();
    
end
%% read data for each page and change it to physical units
% This is to get the data. It automatically takes all the pages detected
%
%
data = read_data();

%% create metadata
%
% %
for i=1:file_header.total_page_count
    metadata{i}.page_header = page_header(i); 
    metadata{i}.string_data = string_data(i);
end

%% close the file

fclose(fid); % close the file

%% output of the program 
% It is a cell with all the structures

% info={file_header, object_list, page_index_header,...
%         page_index, page_index_array, page_header,...
%         object_list_string, string_data, data, metadata};
%     
info = {data,metadata};
    
%%    
%%%%%%%%%%%%%%%%%
% START WITH EACH FUNCTION DEFINITION
%%%%%%%%%%%%%%%%%
%% READ FILE HEADER
%
%
%%%%%%%%%%%
    function out = read_file_header(); %reads the header of the file
        out.header_size = fread(fid, 1, 'uint16');
        out.signature = fread(fid, 18, 'uint16=>char');
        out.total_page_count = fread(fid, 1, 'uint32');
        out.object_list_count = fread(fid, 1, 'uint32');
        out.object_field_size = fread(fid, 1, 'uint32');
        out.reserved = fread(fid, 2, 'uint32');       
    end
%%  Generic read objects: used to read the data that localize each object
%
%
%%%%%%%%%%%
    function out = read_objects()
        out.objectID = fread(fid,1,'uint32');   % 4 bytes
        % line that does not read
        out.object_name = object_type(find(object_type(1).code == out.objectID)).name;
        out.offset = fread(fid,1,'uint32');     % 4 bytes
        out.size = fread(fid,1,'uint32');       % 4 bytes
    end
%%
%
%
%%%%%%%%%%%
    function out = read_page_index_header()
        out.page_count = fread(fid,1,'uint32'); % the number of pages in the page index array
        out.object_list_count= fread(fid,1,'uint32'); 
        out.reserved = fread(fid, 2, 'uint32');  
    end
%% Function: read_page_index
% this function reads the page index
%
%
%%%%%%%%%%%
    function out = read_page_index()
%         out.page_id = fread(fid,1,'uint32'); % unique ID for each page
        out.page_id = fread(fid, 8, 'uint16');
        out.page_data_type = fread(fid,1,'uint32'); % data type
    %%%%%%%%%%% esto deberia ser un diccionario
    % % Data type ID
    % data_type = 
%     data_type{1,1} = RHK_DATA_IMAGE = 0,...
    % RHK_DATA_LINE = 1,...
    % RHK_DATA_XY_DATA = 2,...
    % RHK_DATA_ANNOTATED_LINE = 3,...
    % RHK_DATA_TEXT = 4,...
    % RHK_DATA_ANNOTATED_TEXT = 5,...
    % RHK_DATA_SEQUENTIAL = 6} %/* Only in RHKPageIndex */
   
        out.page_source_type = fread(fid,1,'uint32');
    % identifiers
    % RHK_SOURCE_RAW = 0,
    % RHK_SOURCE_PROCESSED = 1,
    % RHK_SOURCE_CALCULATED = 2,
    % RHK_SOURCE_IMPORTED = 3,
        out.object_list_count = fread(fid,1,'uint32'); % object count
        out.minorv = fread(fid,1,'uint32'); % minor version
    end
%% Function: Read_page_header.
% This function reads the page header
%
%
%%%%%%%%%%%
    function out = read_page_header()
%         out.field_size = fread(fid, 1, 'short');
%         out.signatures = fread(fid, 18, 'int16=>char'); % 
% I do not read the field_size and the signature that is explained in the
% manual. 
% I just skip 3 bytes and it works!  (next fseek)
        fseek(fid,3,0);                                 % Skiping 3 bytes. Unkwonw reason.
        out.string_count = fread(fid,1,'short');        % 2 bytes        
%         out.type = fread(fid,1,'int32');              % 4 bytes
% it looks like the manual is not right. There is only one type and it
% seems to be page_type.
        out.page_type = fread(fid,1,'uint32');          % 4 bytes
        % Line that does not read: to put the corresponding name
        out.page_type_name = image_type(find(image_type(1).code==out.page_type)).name;
        out.data_sub_source = fread(fid,1,'uint32');    % 4 bytes
        % Line that does not read: to put the corresponding name
        out.data_sub_source_name = source_image(find(source_image(1).code == out.data_sub_source)).name; 
        out.line_type = fread(fid,1,'uint32');          % 4 bytes
        % Line that does not read: to put the corresponding name
        out.line_type_name = line_type(find(line_type(1).code == out.line_type)).name;
        out.xy = fread(fid,4,'uint32');                 % 16 bytes
            out.x_corner = out.xy(1);
            out.y_corner = out.xy(2); % interpret th 4-size structure
            out.width = out.xy(3);
            out.height = out.xy(4);
% AGAIN: I do not read the source_type, as it is indicated at the manual
%         out.source_type = fread(fid,1,'int32');         % 4 bytes
        out.image_type = fread(fid,1,'int32');          % 4 bytes
        % Line that does not read: to put the corresponding name
        out.image_type_name2 = image_type2(find(image_type2(1).code==out.image_type)).name;     
        out.scan_dir = fread(fid,1,'uint32');           % 4 bytes
        % Line that does not read: to put the corresponding name
        out.scan_dir_name = scan_dir(find(scan_dir(1).code==out.scan_dir)).name;
        out.group_id = fread(fid,1,'int32');            % 4 bytes
        % many pages can be aquired in each page
        out.page_data_size = fread(fid,1,'ulong');      % 4 bytes
        out.min_z_value = fread(fid,1,'int32');         % 4 bytes
        out.max_z_value = fread(fid,1,'int32');         % 4 bytes
        out.x_scale = fread(fid,1,'float32');           % 4 bytes
        out.y_scale = fread(fid,1,'float32');           % 4 bytes
        out.z_scale = fread(fid,1,'float32');           % 4 bytes
        out.xy_scale = fread(fid,1,'float');            % 4 bytes
        out.x_offset = fread(fid,1,'float');            % 4 bytes
        out.y_offset = fread(fid,1,'float');            % 4 bytes
        out.z_offset = fread(fid,1,'float');            % 4 bytes
        out.period = fread(fid,1,'float32');            % 4 bytes
        out.bias = fread(fid,1,'float32');              % 4 bytes
        out.current = fread(fid,1,'float32');           % 4 bytes
        out.angle = fread(fid,1,'float32');             % 4 bytes
        out.color_info_count = fread(fid,1,'int32');    % 4 bytes
        out.grid_x_size = fread(fid,1,'int32');         % 4 bytes
        out.grid_y_size = fread(fid,1,'int32');         % 4 bytes
        out.reserved = fread(fid,16,'uint32');          % 16 bytes
    
    end
%% Function: read string data
%
%
%%%%%%%%%%%
    function out = read_string_data();
        for i=1:17
            count = fread(fid,1,'uint16');
            aux(i).str = fread(fid,count,'uint16=>char')';
        end
        out.Label = aux(1).str; % String that goes on the top of the plot window, 
                                % like 'Current Image'.
        out.System_Text = aux(2).str;   % A comment describing the data.
        out.Session_Text = aux(3).str;  % General session comments.
        out.User_Text = aux(4).str;     % User comments.
        out.Path = aux(5).str;          % Path and name of the SM4 file, which holds the page.
        out.Date = aux(6).str;          % Stores the date at which data is acquired.
        out.Time = aux(7).str;          % Stores the time at which data is acquired.
        out.X_Units = aux(8).str;       % Physical units of that axis, like m or V.
        out.Y_Units = aux(9).str;       % Physical units of that axis.
        out.Z_Units = aux(10).str;      % Physical units of that axis.
        out.X_Label = aux(11).str;      %
        out.Y_Label = aux(12).str;      % 
        out.Status_Channel_Text = aux(13).str;      % Status channel text
        out.strCompletedLineCount = aux(14).str;    % Completed line count info. 
                                                    % This string contains the last saved
                                                    % line count for an image data page. 
                                                    % For all other pages, this value will be zero.
        out.StrOverSamplingCount =aux(15).str;      % This string contains the Oversampling count 
                                                    % for image data pages. For all other pages 
                                                    % this value will be zero.
        out.StrSlicedVoltage =aux(16).str;          % The voltage at which the sliced image is 
                                                    % created from the spectra page. This string
                                                    % will be empty for pages other than sliced image pages.
        out.StrPLLProStatus = aux(17).str;           % This string contains the PLLPro status text, 
                                                    % if the operating mode is selected as PLLPro 
                                                    % master or PLLPro user.
        clear aux
    end

% %% Function Sequencial_data_page
%     function out=read_sequencial_data_page();
%         out.data_type = fread(fid,1,'int32');
%             % 1 = Spec Drift (Stores the SSpecInfo structure as the Data, Param Count gives the
%             % number of float data in this structure.)
%             % 2 = Image Drift (Stores the SImageDrift structure as the Data, Param Count gives the
%             % number of float data in this structure.)
%             % 3 = Tip Track (Stores the StipTrackInfo structure as the Data, Param Count gives the
%             % number of float data in this structure.)
%         out.data_length = fread(fid,1,'int32');
%     end

%% Function: Read_data
%
%
%%%%%%%%%%%
    function out=read_data();
        for j=1:page_index_header.page_count
            fseek(fid,page_index_array(j,2).offset-1,'bof');
            aux = fread(fid,page_index_array(j,2).size/4,'int32','l');
            % /4 is because the total data size has to be divided
            % by the numer of bytes that use each 'long' data
            
            % change to physical units the measured data
            aux2 = page_header(j).z_offset+double(aux)*page_header(j).z_scale/256;
            % for some unkwon reason, to get the right scale I have to
            % dived by 256.
            %
            % reshape to build a matix
            out{j}.z = reshape(aux2,page_header(j).width,page_header(j).height);
            out{j}.x=page_header(j).x_offset+(0:page_header(j).width-1)*page_header(j).x_scale;
            out{j}.y=page_header(j).y_offset+(0:page_header(j).height-1)*page_header(j).y_scale;
        end
        
    end




end
