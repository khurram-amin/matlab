% This function will compute the overlap-area between two rectangles 
% and if the ratio of intersection area between two rectangles and the 
% union of those two rectangles is greater than 'overlap_threshold', then it
% will discard the lower scoring rectangle

% BB = [M x 4] array with M bounding boxes
%      format of each row = [xmin, ymin, xmax, ymax]
%
% conf = [M x 1] array, representing confidences of each bounding box
%
% overlap_thresh = [1 x 1] scalar raninging from 0-1, representing the threshold at which to discard overlaping windows
%                  e.g. if set to 0.5, the windows having 50% overlap will be replaced by one higher scoring window.
%
% example: [pruned_bb, pruned_scores] = iou([1,1,720,1280; 1, 1, 360, 640], [1, 5], 0.5)
function [pruned_bb, pruned_conf] = iou(BB, conf, overlap_thresh)

    timespent = tic;
    pruned_bb = BB;
    pruned_conf = conf;
    for i = 1:size(BB,1)-1
        for j = i+1:size(BB,1)

            overlap = bboxOverlapRatio( BB(i,:), BB(j,:) );
            if overlap >= overlap_thresh
                if conf(i) > conf(j)
                    pruned_bb(j,:) = 0;
                    pruned_conf(j) = 0;
                else
                    pruned_bb(i,:) = 0;
                    pruned_conf(i) = 0;
                end
            end
        end
    end

    pruned_bb( pruned_bb(:,1) == 0, : ) = [];
    pruned_conf( pruned_conf == 0 ) = [];
    fprintf( 'Total time spent in iou.m is = %d\n', toc(timespent) );
end