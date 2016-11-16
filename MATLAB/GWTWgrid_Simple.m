function [JetsMagnitude, JetsPhase, GridPosition] = GWTWgrid_Simple(Im,ComplexOrSimple,GridSize,Sigma, sizes, ors)

%%
%% The goal of this function is to transform a image with gabor wavelet
%% method, and then convolution values at limited positions of the image
%% will be choosed as output
%%
%% Usage: [JetsMagnitude, JetsPhase, GridPosition] = GWTWgrid_Simple(Im,ComplexOrSimple,GridSize,Sigma)
%%
%% Now i use sizes, ors 
%% Inputs to the function:
%%   Im                  -- The image you want to reconstruct with this function
%%
%%   ComplexOrSimple     -- If input is 0, the JetsMagnitude would be complex (imaginary) cell responses (40 values) (default)
%%                          If input is 1, the JetsMagnitude would be simple (non imaginary) cell responses (80 values)
%%
%%   GridSize            -- If input is 0, grid size is 10*10 (default);
%%                          If input is 1, grid size is 12*12 ;
%%                          If input is 2, grid size would be the image size (128*128 or 256*256)
%%
%%   Sigma               -- control the size of gaussion envelope
%%
%%
%% Outputs of the functions:
%%   JetsMagnitude       -- Gabor wavelet transform magnitude
%%   JetsPhase           -- Gabor wavelet transform phase
%%   GridPosition        -- postions sampled
%%
%% Created by Xiaomin Yue at 7/25/2004
%%
%% Last updated: 12/24/2004
%%

if nargin < 1
    disp('Please input the image you want to do gabor wavelet transform.');
    return;
end

if nargin < 2
    ComplexOrSimple = 0;
    GridSize = 0;
    Sigma = 2*pi;
end

if nargin < 3
    GridSize = 0;
    Sigma = 2*pi;
end

if nargin < 4
    Sigma = 2*pi;
    sizes = 5; 
    ors = 8;
end

if nargin < 7
    mode = 'whole';
end
    

%% FFT of the image
Im = double(Im);
ImFreq = fft2(Im);
imagesc((real(ifft2(ImFreq)))) % no need to fftshift when mapped back to an image? 
[SizeX,SizeY] = size(Im);

%% generate the grid
if SizeX==256
    if GridSize == 0 % 10*10 
        RangeX = 40:20:220;
        RangeY = 40:20:220; 
        % set rangeX and rangeY to be 
    elseif GridSize == 1
        RangeXY = 20:20:240; 
    else
        RangeXY = 1:256; % the entire image
    end    
    [xx,yy] = meshgrid(RangeXY,RangeXY); % meshgrids so cool! pass in 1 (2nd opt) vector of values for every x, 2nd value is a vector of how many times it will be replicated.
    Grid = xx + yy*1i;
    Grid = Grid(:); % vectorizes the grid
elseif SizeX==48
    if GridSize == 0 % 10 * 10
        RangeX = 4:4:40; 
        RangeY = 4:4:40;
    else
        RangeX = 1:48; % just all of it
        RangeY = 1:48;
    end    
    [xx,yy] = meshgrid(RangeX,RangeY);
    Grid = xx + yy*i;
    Grid = Grid(:);
else
    disp('The image has to be 256*256 or 128*128 or 48*48. Please try again');
    return;
end
GridPosition = [imag(Grid) real(Grid)];

%% setup the paramers
nScale = sizes; nOrientation = ors;
xyResL = SizeX; xHalfResL = SizeX/2; yHalfResL = SizeY/2;
kxFactor = 2*pi/xyResL; 
kyFactor = 2*pi/xyResL;

%% setup space coordinate 
[tx,ty] = meshgrid(-xHalfResL:xHalfResL-1,-yHalfResL:yHalfResL-1);  
tx = kxFactor*tx; % rows that go from -pi -> pi (size = the size of the image). 
ty = kyFactor*(-ty); % columns that go from pi -> -pi (size = the size of the image).

%% initiallize useful variables
if ComplexOrSimple == 0
    JetsMagnitude  = zeros(length(Grid),nScale*nOrientation);
    JetsPhase      = zeros(length(Grid),nScale*nOrientation);
else
    JetsMagnitude  = zeros(length(Grid),2*nScale*nOrientation);
    JetsPhase      = zeros(length(Grid),nScale*nOrientation);
end

for LevelL = 0:nScale-1
    k0 = (pi/2)*(1/sqrt(2))^LevelL; % the size of the kernel
%     sprintf('k0 is %d', k0) % smaller as number goes up (1.57 -> 1.11 ... ) as (1/sqrt(2))^x
    for DirecL = 0:nOrientation-1
        kA = pi*DirecL/nOrientation;
        k0X = k0*cos(kA);
        k0Y = k0*sin(kA);
        %% generate a kernel specified scale and orientation, which has DC on the center
        %% the kernel is a 48*48 image, and has DC = the value of the MEAN freq of the images 
        %% and is real-valued
        FreqKernel = 2*pi*(exp(-(Sigma/k0)^2/2*((k0X-tx).^2+(k0Y-ty).^2))-exp(-(Sigma/k0)^2/2*(k0^2+tx.^2+ty.^2)));
        %% use fftshift to change DC back the corners - the way it should be (but unintuitive)
        FreqKernel = fftshift(FreqKernel);
        % visualizing kernels in spatial domain
%         subplot(nScale, nOrientation, LevelL*nOrientation+DirecL+1);
%         imagesc(fftshift(real(ifft2(FreqKernel)))); 
%         colormap gray;
%         title(sprintf('size %d, orientation %d', LevelL, DirecL));
%         
        %% convolute the image with a kernel specified scale and orientation
        TmpFilterImage = ImFreq.*FreqKernel; % convolution is just an inner product: freqKernel 
%         subplot(nScale, nOrientation, LevelL*nOrientation+DirecL+1);
%         imagesc(real(ifft2(TmpFilterImage)));
%         colormap gray
        %% calculate magnitude and phase
        if ComplexOrSimple == 0
            TmpGWTMag = abs(ifft2(TmpFilterImage)); % returns ck = sqrt(ak^2 + bk^2), real^2 + imag^2
            TmpGWTPhase = angle(ifft2(TmpFilterImage)); % reutnrs ck = arctan(bk/ak) but what angle is this? always +- pi
            %% get magnitude and phase at specific positions
            tmpMag = TmpGWTMag(RangeX,RangeY);
            tmpMag = (tmpMag');
            JetsMagnitude(:,LevelL*nOrientation+DirecL+1)=tmpMag(:); % appends them as a column vector
            
            tmpPhase = TmpGWTPhase(RangeX,RangeY);
            tmpPhase = (tmpPhase')+ pi;
            JetsPhase(:,LevelL*nOrientation+DirecL+1)=tmpPhase(:);
        else
            TmpGWTMag_real = (real(ifft2(TmpFilterImage)));
            TmpGWTMag_imag = (imag(ifft2(TmpFilterImage)));
            TmpGWTPhase = angle(ifft2(TmpFilterImage));
            %% get magnitude and phase at specific positions
            tmpMag_real = TmpGWTMag_real(RangeXY,RangeXY);
            tmpMag_real = (tmpMag_real');
            tmpMag_imag = TmpGWTMag_imag(RangeXY,RangeXY);
            tmpMag_imag = (tmpMag_imag');
            JetsMagnitude_real(:,LevelL*nOrientation+DirecL+1) = tmpMag_real(:);
            JetsMagnitude_imag(:,LevelL*nOrientation+DirecL+1) =  tmpMag_imag(:);
            tmpPhase = TmpGWTPhase(RangeXY,RangeXY);
            tmpPhase = (tmpPhase')+ pi;
            JetsPhase(:,LevelL*nOrientation+DirecL+1)=tmpPhase(:);            
        end    
    end
end    

if ComplexOrSimple ~=0
    JetsMagnitude = [JetsMagnitude_real JetsMagnitude_imag];
end

