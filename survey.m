classdef survey
    %SURVEY DC resistivity measurement
    %

    properties
        type
        total_num_box
        total_num_ele
        number_of_boxes
        num_ele
        d
        n_min
        n_max
        offset_ele
        exclude_ele
        exclude_box
        coords
        rhoa
        voltage
        current
        box
        ABMN_MEA
        ABMN_BERT
        k
        num_data
        valid
    end

    methods
        function obj = survey(type, total_num_box, total_num_ele, ...
                d, n_min, n_max, offset_ele, exclude_ele, exclude_box)
            %SURVEY Constructor for a DC measurement
            % survey(type, total_num_box, total_num_ele, d, ...
            %        n_min, n_max, offset_ele, exclude_ele, exclude_box)
            if nargin < 8
                exclude_ele = [];
                exclude_box = [];
            end
            assert(ischar(type) && any(strcmpi(type, ...
                {'wenner', 'dipole-dipole',...
                'pol-dipole-fw', 'pol-dipole-rv'})), ...
                ['DC measurement configuration ', ...
                'not recognized.']);
            assert(total_num_ele > 0, 'Number of electrodes must be > 0.')
            assert(n_min <= n_max, 'Max n must be less or equal to n_min.')

            box = 1:total_num_box;
            num_box_exclude = length(exclude_box);
            var = floor(((d * total_num_box) - total_num_ele) / d);
            first = num_box_exclude + total_num_box - var + 1;
            box([exclude_box, box(first:total_num_box)]) = [];
            num_ele = length(box);

            obj.box = box;

            new_n_max = my_consistency_test(obj, type, ...
                total_num_box, ...
                total_num_ele, ...
                offset_ele, ...
                exclude_ele, ...
                exclude_box, ...
                n_min, ...
                n_max, ...
                num_ele, ...
                d);
            obj.n_max = new_n_max;

            obj.type = type;

            obj.total_num_ele = total_num_ele;
            obj.total_num_box = total_num_box;

            obj.number_of_boxes = total_num_box;
            obj.num_ele = num_ele;


            obj.d = d;
            obj.n_min = n_min;

            obj.offset_ele = offset_ele;
            obj.exclude_ele = exclude_ele;
            obj.exclude_box = exclude_box;

            x = 0:(num_ele - 1);
            x = x * obj.d;
            z = zeros(num_ele, 1);
            obj.coords = [x(:) z(:)];

            obj.ABMN_MEA = [];
            obj.ABMN_BERT = [];
            obj.k = []; %zeros(obj.num_data, 1);
            

            switch lower(obj.type)
                case 'wenner'
                    obj = wenner(obj);
                case 'dipole-dipole'
                    obj = dipole_dipole(obj);
                case 'pol-dipole-fw'
                    obj = pole_dipole_fw(obj);
                case 'pol-dipole-rv'
                    obj = pole_dipole_rv(obj);
                otherwise
                    warning('Array configuration not recognized.');
            end

            obj.num_data = size(obj.ABMN_BERT, 1);
            obj.rhoa = -99 * ones(obj.num_data, 1);
            obj.valid = zeros(obj.num_data, 1);
        end

        function obj = wenner(obj)
            for n = obj.n_min:obj.n_max
                idx_cur_A_max = obj.num_ele - 3 * n;
                kfactor = 2 * pi * obj.d * n;
                for idx_cur_A = 1:idx_cur_A_max
                    % derive the indices for boxes B, M, N
                    idx_cur_B = idx_cur_A + 3 * n;
                    idx_cur_M = idx_cur_A + n;
                    idx_cur_N = idx_cur_A + 2 * n;

                    % derive the indices for electrodes A, B, M, N
                    % idx_pos_A = idx_cur_A * obj.d - (obj.d - 1);
                    % idx_pos_B = idx_pos_A + 3 * n * obj.d;
                    % idx_pos_M = idx_pos_A + n * obj.d;
                    % idx_pos_N = idx_pos_A + 2 * n * obj.d;

                    idx_pos_A = idx_cur_A;
                    idx_pos_B = idx_cur_B;
                    idx_pos_M = idx_cur_M;
                    idx_pos_N = idx_cur_N;

                    % Get box and position numbers
                    [cur_A, cur_B, cur_M, cur_N, pos_A, pos_B, pos_M, pos_N] = ...
                        box_and_position_number(obj.box, obj.offset_ele,...
                        idx_cur_A, idx_cur_B,...
                        idx_cur_M, idx_cur_N,...
                        idx_pos_A, idx_pos_B,...
                        idx_pos_M, idx_pos_N);

                    if pos_B <= obj.total_num_ele
                        if ~ismember(pos_A, obj.exclude_ele) && ~ismember(pos_M, obj.exclude_ele) && ...
                                ~ismember(pos_N, obj.exclude_ele) && ~ismember(pos_B, obj.exclude_ele)

                            obj.ABMN_MEA = [obj.ABMN_MEA; [cur_A, cur_B, cur_M, cur_N]]; % for MEA
                            obj.ABMN_BERT = [obj.ABMN_BERT; [pos_A, pos_B, pos_M, pos_N]]; % for MEA
                            obj.k = [obj.k; kfactor];

                            %                         fprintf(sprintf(['n:%2d \t Box_A:%2d Box_M:%2d Box_N:%2d '...
                            %                             'Box_B:%2d\t\t Ele_A:%2d Ele_M:%2d Ele_N:%2d Ele_B:%2d\n'],...
                            %                             n, cur_A, cur_M, cur_N, cur_B, pos_A, pos_M, pos_N, pos_B));
                        end
                    end

                end

            end

        end  %wenner

        function obj = dipole_dipole(obj)
            for n = obj.n_min:obj.n_max
                idx_cur_A_max = obj.num_ele - 2 * n + (n - 2);
                kfactor = pi * n * (n + 1) * (n + 2) * obj.d;
                for idx_cur_A = 1:idx_cur_A_max
                    % derive the indices for boxes B, M, N
                    idx_cur_B = idx_cur_A + 1;
                    idx_cur_M = idx_cur_A + 1 + n;
                    idx_cur_N = idx_cur_A + 2 + n;

                    % derive the indices for electrodes A, B, M, N
                    % idx_pos_A = idx_cur_A * obj.d - (obj.d - 1);
                    % idx_pos_B = idx_pos_A + obj.d;
                    % idx_pos_M = idx_pos_A + (n + 1) * obj.d;
                    % idx_pos_N = idx_pos_A + (n + 2) * obj.d;

                    idx_pos_A = idx_cur_A;
                    idx_pos_B = idx_cur_B;
                    idx_pos_M = idx_cur_M;
                    idx_pos_N = idx_cur_N;


                    % Get box and position numbers
                    [cur_A, cur_B, cur_M, cur_N, pos_A, pos_B, pos_M, pos_N] = ...
                        box_and_position_number(obj.box, obj.offset_ele,...
                        idx_cur_A, idx_cur_B,...
                        idx_cur_M, idx_cur_N,...
                        idx_pos_A, idx_pos_B,...
                        idx_pos_M, idx_pos_N);

                    if pos_N <= obj.total_num_ele
                        if ~ismember(pos_A, obj.exclude_ele) && ~ismember(pos_M, obj.exclude_ele) && ...
                                ~ismember(pos_N, obj.exclude_ele) && ~ismember(pos_B, obj.exclude_ele)
                            obj.ABMN_MEA = [obj.ABMN_MEA; [cur_A, cur_B, cur_M, cur_N]]; % for MEA
                            obj.ABMN_BERT = [obj.ABMN_BERT; [pos_A, pos_B, pos_M, pos_N]]; % for MEA
                            obj.k = [obj.k; kfactor];
                        end
                    end

                end

            end

        end % dipole-dipole

        function obj = pole_dipole_fw(obj)
            for n = obj.n_min:obj.n_max
                idx_cur_A_max = obj.num_ele - (n + 1);
                kfactor = 2 * pi * n * (n + 1) * obj.d;
                for idx_cur_A = 1:idx_cur_A_max
                    % derive the indices for boxes B, M, N
                    idx_cur_B = 0;
                    idx_cur_M = idx_cur_A + n;
                    idx_cur_N = idx_cur_A + 1 + n;

                    % derive the indices for electrodes A, B, M, N
                    % idx_pos_A = idx_cur_A * obj.d - (obj.d - 1);
                    % idx_pos_B = 0;
                    % idx_pos_M = idx_pos_A + n * obj.d;
                    % idx_pos_N = idx_pos_A + (n + 1) * obj.d;

                    idx_pos_A = idx_cur_A;
                    idx_pos_B = idx_cur_B;
                    idx_pos_M = idx_cur_M;
                    idx_pos_N = idx_cur_N;


                    % Get box and position numbers
                    [cur_A, cur_B, cur_M, cur_N, pos_A, pos_B, pos_M, pos_N] = ...
                        box_and_position_number(obj.box, obj.offset_ele,...
                        idx_cur_A, idx_cur_B,...
                        idx_cur_M, idx_cur_N,...
                        idx_pos_A, idx_pos_B,...
                        idx_pos_M, idx_pos_N);

                    if pos_N <= obj.total_num_ele
                        if ~ismember(pos_A, obj.exclude_ele) && ~ismember(pos_M, obj.exclude_ele) && ...
                                ~ismember(pos_N, obj.exclude_ele) && ~ismember(pos_B, obj.exclude_ele)
                            obj.ABMN_MEA = [obj.ABMN_MEA; [cur_A, cur_B, cur_M, cur_N]]; % for MEA
                            obj.ABMN_BERT = [obj.ABMN_BERT; [pos_A, pos_B, pos_M, pos_N]]; % for MEA
                            obj.k = [obj.k; kfactor];
                        end
                    end

                end

            end

        end % pole_dipole_fw

        function obj = pole_dipole_rv(obj)
            for n = obj.n_min:obj.n_max
                kfactor = pi * n * (n + 1) * (n + 2) * obj.d;
                for idx_cur_A = (n + 2):obj.num_ele
                    % derive the indices for boxes B, M, N
                    idx_cur_B = 0;
                    idx_cur_M = idx_cur_A - n;
                    idx_cur_N = idx_cur_A - n - 1;

                    % derive the indices for electrodes A, B, M, N
                    % idx_pos_A = idx_cur_A * obj.d - (obj.d - 1);
                    % idx_pos_B = 0;
                    % idx_pos_M = idx_pos_A - n * obj.d;
                    % idx_pos_N = idx_pos_A - (n + 1) * obj.d;

                    idx_pos_A = idx_cur_A;
                    idx_pos_B = idx_cur_B;
                    idx_pos_M = idx_cur_M;
                    idx_pos_N = idx_cur_N;


                    % Get box and position numbers
                    [cur_A, cur_B, cur_M, cur_N, pos_A, pos_B, pos_M, pos_N] = ...
                        box_and_position_number(obj.box, obj.offset_ele,...
                        idx_cur_A, idx_cur_B,...
                        idx_cur_M, idx_cur_N,...
                        idx_pos_A, idx_pos_B,...
                        idx_pos_M, idx_pos_N);

                    if pos_A <= obj.total_num_ele
                        if ~ismember(pos_A, obj.exclude_ele) && ~ismember(pos_M, obj.exclude_ele) && ...
                                ~ismember(pos_N, obj.exclude_ele) && ~ismember(pos_B, obj.exclude_ele)
                            obj.ABMN_MEA = [obj.ABMN_MEA; [cur_A, cur_B, cur_M, cur_N]]; % for MEA
                            obj.ABMN_BERT = [obj.ABMN_BERT; [pos_A, pos_B, pos_M, pos_N]]; % for MEA
                            obj.k = [obj.k; kfactor];
                        end
                    end

                end

            end

        end % pole_dipole_rv

        function [n_max, obj] = my_consistency_test(obj, type, total_num_box, total_num_ele,...
                offset_ele, exclude_ele, exclude_box,...
                n_min, n_max, num_ele, d)


            mustBePositive(n_min);      % input n_min is positive
            mustBePositive(n_max);      % input n_max is positive
            assert(n_min <= n_max);     % n_min has to be equal or smaller than n_max
            assert(isempty(exclude_ele) || max(exclude_ele) <= total_num_ele);
            assert(isempty(exclude_box) || max(exclude_box) <= total_num_box);
            assert(total_num_box > 0);  % total_num_box has to be greater than zero
            assert(total_num_ele > 0);  % total_num_ele has to be greater than zero
            assert(offset_ele >= 0);    % offset_ele has to be greater or equal zero
            assert(d > 0);

            % Elements in exclude_ele must be greater than zero
            for exclude = 1:length(exclude_ele)
                if exclude_ele(exclude) <= 0
                    %         warning('Element in ele_exclude is negative or zero.');
                end
            end

            % Elements in exclude_box must be greater than zero
            for exclude = 1:length(exclude_box)
                if exclude_box(exclude) <= 0
                    %         warning('Element in box_exclude is negative or zero.');
                end
            end

            % Checking n_min and n_max.
            switch type
                case 'wenner'
                    assert(num_ele >= 4);
                    assert(n_min <= (num_ele - 1) / 3);

                    % If n_max is set to high it will be reduced to the maxial n.
                    if n_max > floor((num_ele - 1) / 3)
                        %             warning('n_max reduced from %d to %d', ...
                        %                 n_max, floor((num_ele - 1) / 3));
                        n_max = floor((num_ele - 1) / 3);
                    end

                case 'pol-dipole-fw'
                    assert(num_ele >= 3);
                    assert(n_min <= num_ele - 2);

                    % If n_max is set to high it will be reduced to the maxial n.
                    if n_max > num_ele - 2
                        % warning('n_max reduced from %d to %d', n_max, num_ele - 2);
                        n_max = num_ele - 2;
                    end

                case 'pol-dipole-rv'
                    assert(num_ele >= 3);
                    assert(n_min <= num_ele - 2);

                    % If n_max is set to high it will be reduced to the maxial n.
                    if n_max > num_ele-2
                        % warning('n_max reduced from %d to %d', n_max, num_ele - 2);
                        n_max = num_ele-2;
                    end

                case 'dipole-dipole'
                    assert(num_ele >= 4);
                    assert(n_min <= num_ele - 3);

                    % If n_max is set to high it will be reduced to the maximal n.
                    if n_max > num_ele - 3
                        % warning('n_max reduced from %d to %d', n_max, num_ele - 3);
                        n_max = num_ele - 3;
                    end
            end
        end % consistency_test

        function save(obj, filename)
            fid = fopen(filename, 'w');
            fprintf(fid, '%d', obj.num_ele);
            fprintf(fid, '# Number of electrodes\n');
            for i=1:obj.num_ele
                fprintf(fid, '%.2f %.2f\n', obj.coords(i, 1), obj.coords(i, 2));
            end
            fprintf(fid, '%d', obj.num_data);
            fprintf(fid, '# Number of data\n');

            if ~any(obj.valid)
                fprintf(fid, '# a b m n\n');
            else
                fprintf(fid, '# a b m n k rhoa\n');
            end

            for i=1:obj.num_data
                if ~any(obj.valid)
                    fprintf(fid, '%3d %3d %3d %3d\n', obj.ABMN_BERT(i, :));
                else
                    fprintf(fid, '%3d %3d %3d %3d %.2f %.2f\n', [obj.ABMN_BERT(i, :) obj.k(i) obj.rhoa(i)]);
                end
            end

            fclose(fid);
        end

    end
end