function data=read_sm4(filename)
% This functions is designed to read the binary data of the .sm4 files,
% produced by the XMpro software (RHK technology Inc.)
%
%
% Created by: M. Caldarola (caldarola@df.uba.ar)
%   Author's comment: I want to thank H. Grecco for his help in this
%                     matter.
% May 2012
%%%%%%%%%%%%%%%%%%%%%%%%

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

%%
page_index_header = read_page_index_header(); % says the number of pages enlisted in the page index array
%% get the page index array
object = read_objects(); % says that the structure we are reading is "page index array"

%% this reads the page index array
% it is an array of (page_count X 4) because for each page we have 4
% structures to read: (PageHeader) (PageData) (Thumbnail) (ThumnailHeader)

for j=1:page_index_header.page_count % this for reads the page index array for each page
    page_index(j) = read_page_index()
    for i=1: page_index(j).object_list_count % this for reads the objects in each column
        aux(i) = read_objects();
    end
    page_index_array(j,:)=aux; % this builds an array of (N x4) where N is the numbers of pages in the file
end
clear aux

%% read page header: use the data in page_idex_array

fseek(fid,page_index_array(1,1).offset-1,'bof'); % seek for the position where the page header is
page_header = read_page_header(); % read the page header with the function defined later in this file


%% after the page_header there is another object list (8 objects)
for i=1:8
    object_list_string(i) = read_objects();
end
% 

% 


%% close the file
fclose(fid); % close the file
%% output of the program: a cell with all the structures
data={file_header, object_list, page_index_header,...
        page_index, page_index_array, page_header,...
        object_list_string};
%%%%%%%%%%%%%%%%%
% START WITH EACH FUNCTION DEFINITION
%%%%%%%%%%%%%%%%%
%% READ FILE HEADER
    function out = read_file_header() %reads the header of the file
        out.header_size = fread(fid, 1, 'uint16');
        out.signature = fread(fid, 18, 'uint16=>char');
        out.total_page_count = fread(fid, 1, 'uint32');
        out.object_list_count = fread(fid, 1, 'uint32');
        out.object_field_size = fread(fid, 1, 'uint32');
        out.reserved = fread(fid, 2, 'uint32');       
    end
%%  Generic read objects: used to read the data that localize each object
    function out = read_objects()
        out.objectID = fread(fid,1,'uint32');   % 4 bytes 
        out.offset = fread(fid,1,'uint32');     % 4 bytes
        out.size = fread(fid,1,'uint32');       % 4 bytes
    end
%%
    function out = read_page_index_header()
        out.page_count = fread(fid,1,'uint32'); % the number of pages in the page index array
        out.object_list_count= fread(fid,1,'uint32'); 
        out.reserved = fread(fid, 2, 'uint32');  
    end
%%
    function out = read_page_index()
%         out.page_id = fread(fid,1,'uint32'); % unique ID for each page
        out.page_id = fread(fid, 8, 'uint16');
        out.page_data_type=fread(fid,1,'uint32'); % data type
    %%%%%%%%%%% esto deberia ser un diccionario
    % % Data type ID
    % data_type = {RHK_DATA_IMAGE = 0,...
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
%%
    function out = read_page_header()
%         out.field_size = fread(fid, 1, 'short');
%         out.signatures = fread(fid, 18, 'int16=>char'); % 
% I do not read the field_size and the signature that is explained in the
% manual. 
% I just skip 3 bytes and it works!  (next fseek)
        fseek(fid,3,0);
        out.string_count = fread(fid,1,'short');        % 2 bytes        
%         out.type = fread(fid,1,'int32');              % 4 bytes
% it looks like the manual is not right. There is only one type and it
% seems to be page_type.
        out.page_type = fread(fid,1,'uint32');          % 4 bytes
        out.data_sub_source = fread(fid,1,'uint32');    % 4 bytes
        out.line_type = fread(fid,1,'uint32');          % 4 bytes
        out.xy = fread(fid,4,'uint32');                 % 16 bytes
            out.x_corner = out.xy(1);
            out.y_corner = out.xy(2); % interpret th 4-size structure
            out.width = out.xy(3);
            out.height = out.xy(4);
% AGAIN: I do not read the source_type, as it is indicated at the manual
%         out.source_type = fread(fid,1,'int32');         % 4 bytes
        out.image_type = fread(fid,1,'int32');          % 4 bytes
        out.scan_dir = fread(fid,1,'uint32');           % 4 bytes
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

%% object type
% RHK_OBJECT_UNDEFINED = 0,
% RHK_OBJECT_PAGE_INDEX_HEADER = 1,
% RHK_OBJECT_PAGE_INDEX_ARRAY = 2,
% RHK_OBJECT_PAGE_HEADER = 3,
% RHK_OBJECT_PAGE_DATA = 4,
% RHK_OBJECT_IMAGE_DRIFT_HEADER = 5,
% RHK_OBJECT_IMAGE_DRIFT = 6,
% RHK_OBJECT_SPEC_DRIFT_HEADER = 7,
% RHK_OBJECT_SPEC_DRIFT_DATA = 8,
% RHK_OBJECT_COLOR_INFO = 9,
% RHK_OBJECT_STRING_DATA = 10,
% RHK_OBJECT_TIP_TRACK_HEADER = 11,
% RHK_OBJECT_TIP_TRACK_DATA = 12,
% RHK_OBJECT_PRM = 13,
% RHK_OBJECT_THUMBNAIL = 14,
% RHK_OBJECT_PRM_HEADER = 15,
% RHK_OBJECT_THUMBNAIL_HEADER = 16,
% RHK_OBJECT_API_INFO = 17,
%/* Our types */
%RHK_OBJECT_FILE_HEADER = -42,
%RHK_OBJECT_PAGE_INDEX = -43,

%% image type
% 
% RHK_PAGE_UNDEFINED = 0,
% RHK_PAGE_TOPOGAPHIC = 1,
% RHK_PAGE_CURRENT = 2,
% RHK_PAGE_AUX = 3,
% RHK_PAGE_FORCE = 4,
% RHK_PAGE_SIGNAL = 5,
% RHK_PAGE_FFT = 6,
% RHK_PAGE_NOISE_POWER_SPECTRUM = 7,
% RHK_PAGE_LINE_TEST = 8,
% RHK_PAGE_OSCILLOSCOPE = 9,
% RHK_PAGE_IV_SPECTRA = 10,
% RHK_PAGE_IV_4x4 = 11,
% RHK_PAGE_IV_8x8 = 12,
% RHK_PAGE_IV_16x16 = 13,
% RHK_PAGE_IV_32x32 = 14,
% RHK_PAGE_IV_CENTER = 15,
% RHK_PAGE_INTERACTIVE_SPECTRA = 16,
% RHK_PAGE_AUTOCORRELATION = 17,
% RHK_PAGE_IZ_SPECTRA = 18,
% RHK_PAGE_4_GAIN_TOPOGRAPHY = 19,
% RHK_PAGE_8_GAIN_TOPOGRAPHY = 20,
% RHK_PAGE_4_GAIN_CURRENT = 21,
% RHK_PAGE_8_GAIN_CURRENT = 22,
% RHK_PAGE_IV_64x64 = 23,
% RHK_PAGE_AUTOCORRELATION_SPECTRUM = 24,
% RHK_PAGE_COUNTER = 25,
% RHK_PAGE_MULTICHANNEL_ANALYSER = 26,
% RHK_PAGE_AFM_100 = 27,
% RHK_PAGE_CITS = 28,
% RHK_PAGE_GPIB = 29,
% RHK_PAGE_VIDEO_CHANNEL = 30,
% RHK_PAGE_IMAGE_OUT_SPECTRA = 31,
% RHK_PAGE_I_DATALOG = 32,
% RHK_PAGE_I_ECSET = 33,
% RHK_PAGE_I_ECDATA = 34,
% RHK_PAGE_I_DSP_AD = 35,
% RHK_PAGE_DISCRETE_SPECTROSCOPY_PP = 36,
% RHK_PAGE_IMAGE_DISCRETE_SPECTROSCOPY = 37,
% RHK_PAGE_RAMP_SPECTROSCOPY_RP = 38,
% RHK_PAGE_DISCRETE_SPECTROSCOPY_RP = 39,


%% line type
% RHK_LINE_NOT_A_LINE = 0,
% RHK_LINE_HISTOGRAM = 1,
% RHK_LINE_CROSS_SECTION = 2,
% RHK_LINE_LINE_TEST = 3,
% RHK_LINE_OSCILLOSCOPE = 4,
% RHK_LINE_NOISE_POWER_SPECTRUM = 6,
% RHK_LINE_IV_SPECTRUM = 7,
% RHK_LINE_IZ_SPECTRUM = 8,
% RHK_LINE_IMAGE_X_AVERAGE = 9,
% RHK_LINE_IMAGE_Y_AVERAGE = 10,
% RHK_LINE_NOISE_AUTOCORRELATION_SPECTRUM = 11,
% RHK_LINE_MULTICHANNEL_ANALYSER_DATA = 12,
% RHK_LINE_RENORMALIZED_IV = 13,
% RHK_LINE_IMAGE_HISTOGRAM_SPECTRA = 14,
% RHK_LINE_IMAGE_CROSS_SECTION = 15,
% RHK_LINE_IMAGE_AVERAGE = 16,
% RHK_LINE_IMAGE_CROSS_SECTION_G = 17,
% RHK_LINE_IMAGE_OUT_SPECTRA = 18,
% RHK_LINE_DATALOG_SPECTRUM = 19,
% RHK_LINE_GXY = 20,
% RHK_LINE_ELECTROCHEMISTRY = 21,
% RHK_LINE_DISCRETE_SPECTROSCOPY = 22,

%% source imgae type
% RHK_SOURCE_RAW = 0,
% RHK_SOURCE_PROCESSED = 1,
% RHK_SOURCE_CALCULATED = 2,
% RHK_SOURCE_IMPORTED = 3,
%% image type
% RHK_IMAGE_NORMAL = 0,
% RHK_IMAGE_AUTOCORRELATED = 1,

%% scan direction
% RHK_SCAN_RIGHT = 0,
% RHK_SCAN_LEFT = 1,
% RHK_SCAN_UP = 2,
% RHK_SCAN_DOWN = 3


end
