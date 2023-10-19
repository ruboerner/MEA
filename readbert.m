clearvars;

filename = 'Erzgang/erz_18_10_2_dd';

fileID = fopen([filename '.mea']);

C = textscan(fileID, '%d', 1, 'CommentStyle', '#');
nel = cell2mat(C);

C = textscan(fileID, '%f %f', nel, 'CommentStyle', '#');
coords = cell2mat(C);

C = textscan(fileID, '%d', 1, 'CommentStyle', '#');
ndata = cell2mat(C);
C = textscan(fileID, '%f %f %f %f %f', ndata, 'CommentStyle', '#');
all = cell2mat(C);
ABMN_BERT = all(:, 1:4);
rhoa = all(:, 5);

[B, I] = sort(ABMN_BERT(1,:));
if isequal(I, [1 3 4 2])
    conf = 'wenner';
elseif isequal(I, [1 2 3 4])
    conf = 'dipole-dipole';
end
fclose(fileID);


s = survey(conf, nel, nel, 0.5, 1, 8, 0, [35 36 40], []);

s.rhoa = rhoa * 0.5;
s.ABMN_BERT = ABMN_BERT;
s.num_data = ndata;

s.save([filename '_new.mea']);