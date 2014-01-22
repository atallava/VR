function spatial_lines = findLinesHT(rangeImage_obj,num_peaks,display_option)
% function to find lines in a 2d range scan
% uses MATLAB's hough functions

if nargin < 2
    num_peaks = 1;
end

rangeImage_obj.createBWImage();
[H,T,R] = hough(rangeImage_obj.im,'Theta',-90:0.5:89.5);
P = houghpeaks(H,num_peaks);
lines = houghlines(rangeImage_obj.im,T,R,P);

spatial_pts = struct('p1',{},'p2',{});
spatial_lines = [];
for i = 1:length(lines)
    id1 = rangeImage_obj.getIDFromRC(lines(i).point1(2),lines(i).point1(1));
    id2 = rangeImage_obj.getIDFromRC(lines(i).point2(2),lines(i).point2(1));
    spatial_pts(i).p1 = [rangeImage_obj.xArray(id1) rangeImage_obj.yArray(id1)];
    spatial_pts(i).p2 = [rangeImage_obj.xArray(id2) rangeImage_obj.yArray(id2)];
    params_abc = ParametrizePts2ABC(spatial_pts(i).p1,spatial_pts(i).p2);
    spatial_lines(:,i) = ParametrizeABC2Rth(params_abc);
end

if display_option
    figure;
    im_coords = imref2d(size(rangeImage_obj.im));
    imshow(~rangeImage_obj.im,im_coords); hold on;
    
    %plot lines in image
    for i = 1:length(lines)
        endpoints = [lines(i).point1; lines(i).point2];
        plot(endpoints(:,1),endpoints(:,2),'LineWidth',2,'color','green');
    end
    hold off;

    % set of hacks to show correct axes on imshow
    xlold = get(gca,'XTickLabel'); ylold = get(gca,'YTickLabel');
    xlnew = linspace(-rangeImage_obj.im_range,rangeImage_obj.im_range,length(xlold)+1);
    ylnew = linspace(-rangeImage_obj.im_range,rangeImage_obj.im_range,length(ylold)+1);
    xlnew = xlnew-mod(xlnew,0.01); % snip away decimal places
    ylnew = ylnew-mod(ylnew,0.01);
    ylnew = fliplr(ylnew); % because y-axis is flipped in the image
    set(gca,'xTickLabel',xlnew(2:end));
    set(gca,'yTickLabel',ylnew(2:end));
    xlabel('x');
    ylabel('y');
end
end