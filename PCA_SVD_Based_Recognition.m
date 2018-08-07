%% SVD and PCA based face Recognition System
% This code is written by Md. Kamrul Hasan
function [Return_recognition_Accuracy, Results_for_Searching]=PCA_SVD_Based_Recognition(Imported_Index_from_Normalizations)
%% Put the Image Directory
% Image (All should be in .jpg format) Read from the directory for Normalization
Training_Image_Imported = dir('D:\uB\Applied Mathematics\Face Recognition Math Project\Final PCA Project Md Kamrul Hasan\Training Image After Normalization\*.jpg');%Giving Directory    
Data_Matrix_Initialization=[];
Labeling_Matrix_Intitialization=[];
for Iteration_1=1:length(Training_Image_Imported)
    Set_Image_Title=Training_Image_Imported(Iteration_1).name; 
    Labeling_Matrix_Intitialization=[Labeling_Matrix_Intitialization;Set_Image_Title(1:3)];                  
    Image_Title = char(strcat('Training Image After Normalization\',Set_Image_Title));
    Image_Read_From_Directory=imread(Image_Title);
    [Row_of_the_Image,Column_of_the_Image]=size(Image_Read_From_Directory);
    Normalized_X_co_ordinate_Pixels=64;
    Normalized_Y_co_ordinate_Pixels=64;
    if(Row_of_the_Image~=Normalized_X_co_ordinate_Pixels||Column_of_the_Image~=Normalized_Y_co_ordinate_Pixels)
      Image_Read_From_Directory=imresize(Image_Read_From_Directory,[Normalized_X_co_ordinate_Pixels Normalized_Y_co_ordinate_Pixels]);
    end
    Reshapping_The_Original_image=reshape(Image_Read_From_Directory,1,Normalized_X_co_ordinate_Pixels*Normalized_Y_co_ordinate_Pixels);%reshape each image from 64x64 to a row vector of 1 to 64x64
    Data_Matrix_Initialization=[Data_Matrix_Initialization;Reshapping_The_Original_image];
end
%To calculate Independent Image, we need to subtract mean from each and
%every Image.
Mean_Image=mean(Data_Matrix_Initialization,2);
[Number_of_row,Number_of_column] = size(Data_Matrix_Initialization);
%Initialization of the Mean Image for the independency
Image_After_Remove = [];
for Iteration_1=1 : Number_of_column
    Reshapping_The_Original_image = double(Data_Matrix_Initialization(:,Iteration_1)) - Mean_Image;
    Image_After_Remove  = [Image_After_Remove Reshapping_The_Original_image];
end
%For PCA, we need Co variance Matrix.
Number_of_Image_for_COV_Matrix=length(Training_Image_Imported)-1;
COV_Mat=(1/Number_of_Image_for_COV_Matrix)*Image_After_Remove*(Image_After_Remove');
%Calculations of Eigen Vectors and Eigen Values from the COV Matrix
[Eigen_Vector,Eigen_Value]=eigs(COV_Mat,length(Training_Image_Imported)-3); 
%Dimension Reduction for PCA 
Reduced_PCA_Image=Image_After_Remove'*Eigen_Vector; 
Feature_Vector_Trainig_Image=[];
for Iteration_1=1:length(Training_Image_Imported)
     Set_Image_Title=Training_Image_Imported(Iteration_1).name; 
     Image_Title = char(strcat('Training Image After Normalization\',Set_Image_Title));
     Image_Read_From_Directory=imread(Image_Title);
     Image_Read_From_Directory=imresize(Image_Read_From_Directory,[Normalized_X_co_ordinate_Pixels Normalized_Y_co_ordinate_Pixels]);
     Reshapping_The_Original_image=reshape(Image_Read_From_Directory,1,Normalized_X_co_ordinate_Pixels*Normalized_Y_co_ordinate_Pixels);
     Trainig_Feature_Vector=double(Reshapping_The_Original_image)*Reduced_PCA_Image;
     Feature_Vector_Trainig_Image=[Feature_Vector_Trainig_Image;Trainig_Feature_Vector];
end
% We need to read the test Image for the recognition
Path_Selection_for_Test_Image=('D:\uB\Applied Mathematics\Face Recognition Math Project\Final PCA Project Md Kamrul Hasan\Test Image After Normalization');
Input_Test=dir('D:\uB\Applied Mathematics\Face Recognition Math Project\Final PCA Project Md Kamrul Hasan\Test Image After Normalization\*.jpg');
Filter = '*.jpg';
selectedFile= Input_Test(Imported_Index_from_Normalizations).name;
Image_Title = char(strcat('Test Image After Normalization\',selectedFile));
Read_Image=imread(Image_Title);
[Row_of_the_Image,Column_of_the_Image]=size(Read_Image);
 if(Row_of_the_Image~=Normalized_X_co_ordinate_Pixels||Column_of_the_Image~=Normalized_X_co_ordinate_Pixels)
    Read_Image=imresize(Read_Image,[Normalized_X_co_ordinate_Pixels Normalized_Y_co_ordinate_Pixels]);
 end
New_test_Image=reshape(Read_Image,1,Normalized_X_co_ordinate_Pixels*Normalized_Y_co_ordinate_Pixels);
Vector_of_Features=double(New_test_Image)*Reduced_PCA_Image;
%Eclidean Distance Calculations
Initialization_of_E_Disdance = [ ];
for Iteration_1=1 : size(Feature_Vector_Trainig_Image,1)
    x = (norm(Vector_of_Features-Feature_Vector_Trainig_Image(Iteration_1,:)))^2;
    Initialization_of_E_Disdance = [Initialization_of_E_Disdance;x];
end
%Minimizations of Eclidean Distance
[Min_Euclidean_Distance,Index_for_Recognized_Image] = min(Initialization_of_E_Disdance);
Results_for_Searching=Training_Image_Imported(Index_for_Recognized_Image).name;
%% Second Part Accuracy Calculations
Initializations_of_Error=0;
Find_the_Test_Image = dir('D:\uB\Applied Mathematics\Face Recognition Math Project\Final PCA Project Md Kamrul Hasan\Test Image After Normalization\*.jpg');
for Iteration_1 = 1 : length(Find_the_Test_Image)
    
 Set_Image_Title=Find_the_Test_Image(Iteration_1).name;
 Selected_Image = char(strcat('Test Image After Normalization\',Set_Image_Title));
 Image_Read=imread(Selected_Image);
 [Row_of_the_Image,Column_of_the_Image]=size(Image_Read);
 if(Row_of_the_Image~=Normalized_X_co_ordinate_Pixels||Column_of_the_Image~=Normalized_Y_co_ordinate_Pixels)
    Image_Read=imresize(Image_Read,[Normalized_X_co_ordinate_Pixels Normalized_Y_co_ordinate_Pixels]);
 end
 Reshape_the_target_image=reshape(Image_Read,1,Normalized_X_co_ordinate_Pixels*Normalized_Y_co_ordinate_Pixels);
 Recording=double(Reshape_the_target_image)*Reduced_PCA_Image; 
 
for Iterator_5=1:length(Training_Image_Imported)
    
    Distance_Vector(Iterator_5) = (norm(Recording-Feature_Vector_Trainig_Image(Iterator_5,:)))^2;    
end
 
 [Minimum_Value,The_index_of_Minimizations]=min(Distance_Vector);

if Labeling_Matrix_Intitialization(The_index_of_Minimizations,1:end)~=Selected_Image(:,32:34);
   Initializations_of_Error=Initializations_of_Error+1;
end
end
Return_recognition_Accuracy=(1-(Initializations_of_Error/length(Find_the_Test_Image)))*100;
% Return_recognition_Accuracy=Initializations_of_Error;
end
%%                    THE END