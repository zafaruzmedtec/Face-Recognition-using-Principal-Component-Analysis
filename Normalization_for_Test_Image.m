%% SVD and PCA based face Recognition System
%This code is written by Md. Kamrul Hasan
%%
clc
close all
clear all
%% Prefined cell
Target_Image_for_Database={};
Selected_5_Features_from_the_Input_database={};
Output_Normalized_Image_64_by_64={};
%% Put the Image Directory
% Image (All should be in .jpg format) Read from the directory for Normalization
Image_for_Normalization=dir('D:\uB\Applied Mathematics\Face Recognition Math Project\Final PCA Project Md Kamrul Hasan\Image and data To be Normalized for testing\*.jpg'); 
% 5 Predefined Features (All should be .txt file) Read from the directory for Normalization
Image_5_Features=dir('D:\uB\Applied Mathematics\Face Recognition Math Project\Final PCA Project Md Kamrul Hasan\Image and data To be Normalized for testing\*.txt');
%% Initial Pre-Processing of the Image and selected Features
for Iteration = 1:length(Image_for_Normalization) 
Set_Image_Title_for_Read = ['Image and data To be Normalized for testing\' Image_for_Normalization(Iteration).name];
Set_Text_Tile_for_Feature = ['Image and data To be Normalized for testing\' Image_5_Features(Iteration).name]; 
Image_Read_for_Processing = imread(Set_Image_Title_for_Read);
% Check is it Color image or not? If color Image, you need convert it to
% Grayscale Image
Index_for_color_Check=size(Image_Read_for_Processing,3);
if Index_for_color_Check>1
   Image_Read_for_Processing = rgb2gray(Image_Read_for_Processing);
end
Target_Image_for_Database{Iteration}=Image_Read_for_Processing;
readtext=textread(Set_Text_Tile_for_Feature);
Selected_5_Features_from_the_Input_database{Iteration}=readtext;
end
%% Define Initial Average Values for the Predefined Features
Initial_Features_Vector=[13,20 ; 50,20 ; 34,34 ; 16,50 ; 48,50];
%% Determination of the Affine Transformation Matrix for each and Every Images
for Iteration_2 = 1:length(Image_for_Normalization)
    %Moore-Penrose pseudoinverse of matrix that returns the Moore-Penrose
    %pseudoinverse of the Equation like x = pinv(A)*b.
    Moore_Penrose_Pseudoinverse = pinv([Selected_5_Features_from_the_Input_database{Iteration_2}, [1;1;1;1;1]]) * Initial_Features_Vector;
    Rotational_Matrix_from_Moore_Penrose_Pseudoinverse = Moore_Penrose_Pseudoinverse(1:2,:); 
    Rotational_Matrix_from_Moore_Penrose_Pseudoinverse = Rotational_Matrix_from_Moore_Penrose_Pseudoinverse';
    Translational_Matrix_from_Moore_Penrose_Pseudoinverse = Moore_Penrose_Pseudoinverse(3,:);
    Translational_Matrix_from_Moore_Penrose_Pseudoinverse = Translational_Matrix_from_Moore_Penrose_Pseudoinverse';
    Image_Read_for_Processing=Target_Image_for_Database{Iteration_2};
    %Memory Allocation for the Normalization of Image
    Normalized_X_co_ordinate_Pixels=64;
    Normalized_Y_co_ordinate_Pixels=64;
    Initialization_of_the_Normalized_Image=uint8(zeros(Normalized_X_co_ordinate_Pixels, Normalized_Y_co_ordinate_Pixels));
    for Iteration=1:Normalized_X_co_ordinate_Pixels
      for Iteration_3=1:Normalized_Y_co_ordinate_Pixels       
          Normalized_Point_Mapping = (pinv(Rotational_Matrix_from_Moore_Penrose_Pseudoinverse)*( [ Iteration; Iteration_3 ] - Translational_Matrix_from_Moore_Penrose_Pseudoinverse ));
          X_cordinate_from_Normalized_Point_Mapping = int32(Normalized_Point_Mapping(1,:));
          Y_cordinate_from_Normalized_Point_Mapping = int32(Normalized_Point_Mapping(2,:));
          if (X_cordinate_from_Normalized_Point_Mapping <= 0)
              X_cordinate_from_Normalized_Point_Mapping  = 1;
          end
          if(Y_cordinate_from_Normalized_Point_Mapping <= 0)
             Y_cordinate_from_Normalized_Point_Mapping = 1;   
          end
          if (X_cordinate_from_Normalized_Point_Mapping >240)
              X_cordinate_from_Normalized_Point_Mapping  = 240;
          end
          if (Y_cordinate_from_Normalized_Point_Mapping >320)
             Y_cordinate_from_Normalized_Point_Mapping = 320;
          end            
          Initialization_of_the_Normalized_Image(Iteration,Iteration_3) = uint8(Image_Read_for_Processing(Y_cordinate_from_Normalized_Point_Mapping, X_cordinate_from_Normalized_Point_Mapping));
      end
    end
    %New Image Title After Normalization
    Set_Image_Title_for_Read = ['Test Image After Normalization\' Image_for_Normalization(Iteration_2).name];
    %Above all the operation Create 90 Degree Rotation of the Normalized
    %Image. So, You need 90 degree rotation of the Normalized Matrix
    Initialization_of_the_Normalized_Image=Initialization_of_the_Normalized_Image';
    Output_Normalized_Image_64_by_64{Iteration_2} = Initialization_of_the_Normalized_Image;
    imwrite(Initialization_of_the_Normalized_Image,Set_Image_Title_for_Read);
    imshow(Initialization_of_the_Normalized_Image)
end
%%                         END of Normalization Code