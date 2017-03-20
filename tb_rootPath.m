function rootPath = tb_rootPath()

% function rootPath = temporalRootPath()

rootPath = which('tb_rootPath');
rootPath = fileparts(fileparts(rootPath));

end