%--------------------------------------------------------------------------
% INSTALL_RLI1
% Project link: https://github.com/danielrherber/reduce-linear-interp1
% This scripts helps you get the reduce-linear-interp1 up and running
%--------------------------------------------------------------------------
% Automatically adds project files to your MATLAB path, and opens an
% example
%--------------------------------------------------------------------------
% Install script based on MFX Submission Install Utilities
% https://github.com/danielrherber/mfx-submission-install-utilities
% https://www.mathworks.com/matlabcentral/fileexchange/62651
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
%--------------------------------------------------------------------------
function INSTALL_RLI1

% add contents to path
AddSubmissionContents(mfilename)

% open an example
OpenThisFile('RLI1_examples')

% close this file
CloseThisFile(mfilename) % this will close this file

end
%--------------------------------------------------------------------------
function AddSubmissionContents(name)
disp('--- Adding submission contents to path')
disp(' ')

% current file
fullfuncdir = which(name);

% current folder
submissiondir = fullfile(fileparts(fullfuncdir));

% add folders and subfolders to path
addpath(genpath(submissiondir))
end
%--------------------------------------------------------------------------
function CloseThisFile(name)
disp(['--- Closing ', name])
disp(' ')

% get editor information
h = matlab.desktop.editor.getAll;

% go through all open files in the editor
for k = 1:numel(h)
    % check if this is the file
    if ~isempty(strfind(h(k).Filename,name))
        % close this file
        h(k).close
    end
end
end
%--------------------------------------------------------------------------
function OpenThisFile(name)
disp(['--- Opening ', name])

try
    % open the file
    open(name);
catch % error
    disp(['Could not open ', name])
end

disp(' ')
end