
%% Use this if you have the circular stats package -
%I arrange my data as Rho1Theta1...RhonThetan in a big old matrix that I
%imported. There are better ways to do this, but I do it that way.  It
%requires that I handle each column one at a time and get rid of the nan
%padding that was done to import it as a matrix.


for i = 1:2:size(A,2)
    m = i+1
    Theta = A(:,m)
    Theta(isnan(Theta))=[]
    Rho = A(:,i)
    Rho(isnan(Rho))=[]
    Coords = [Rho Theta]
    NewTheta = mod(Theta - circ_mean(Theta),2*pi)%This bit finds the mean center and subtracts it from each angle.  To ensure that the outcome is still 0 to 2pi you use the mod function.
    NewCoords = [Rho NewTheta]
    B=NewCoords(:,2)
    C=NewCoords(:,1)
    NewThetaValues{i}=B(:,1)
    RhoValues{i}=C(:,1)
    RealignedCoordinates{i}=[C(:,1) B(:,1)]%This now has all of the points shifted so that the circle mean is at 0
end

%I can't explain why I just like matrices so I conver the cells back into
%matrices. I assume I will outgrow this at some point

for p = 1:2:size(A,2)
    J=cell2mat(NewThetaValues(1,p))
    RealignedThetaOut(1:size(J),p)=J
end


%% If you don't have the circstats package getting mean center is still trivially easy
%Convert polar coordinates to cartesian unit coordinates
UnitCircleX = cos(A(:,2))
UnitCircleY = sin(A(:,2))
UnitCircleXY = [UnitCircleX UnitCircleY]
Mean_Vector_Angle = atan((mean(UnitCircleY))/(mean(UnitCircleX)))
