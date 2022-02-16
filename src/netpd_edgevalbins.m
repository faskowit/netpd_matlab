function [edge_bins] = netpd_edgevalbins(D1,D2,bintype,nbins) 
% get reasonable edge_bins for two distance matricies

if nargin < 3
   bintype = 'sturges' ; 
end

if nargin <4
   nbins = 50 ;  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v1 = D1(~eye(size(D1))) ;
v2 = D2(~eye(size(D2))) ;

combo = unique([v1 ; v2]) ;

%Set up bins by distance (modified from Gollo2018 code)
switch bintype
    case 'sturges'
        [~,edge_bins] = histcounts(combo,'BinMethod','sturges') ;
    case 'quantiles'
        %bin by quantiles (bins contain equal numbers of edges)
        if nbins>2
            edge_bins=[min(combo) quantile(combo,nbins-1) max(combo)+eps]; 
        elseif nbins==2
            edge_bins=[min(combo) median(combo) max(combo)+eps];
        else
            edge_bins=[min(combo) max(combo)+eps];
        end
    case 'equalwidth'
        %bin into fixed-width bins 
        edge_bins=linspace(min(combo),max(combo)+eps,nbins+1);
    otherwise
        error('invalid bintype: %s',bintype)
end
