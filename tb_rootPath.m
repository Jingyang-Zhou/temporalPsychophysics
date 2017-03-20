function rootPath = tBevRootPath()

% function rootPath = temporalRootPath()

rootPath = which('tBevRootPath');
rootPath = fileparts(fileparts(rootPath));

end