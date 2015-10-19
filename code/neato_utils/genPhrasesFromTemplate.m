function snippet = genPhrasesFromTemplate(phraseTemplate,stock,replacements)
% automating generation of repetitive phrases

snippet = [];

for i = 1:length(replacements)
	line = phraseTemplate;
	line = strrep(line,stock,replacements{i});
	line = sprintf('%s\n',line);
	fprintf('%s',line);
	snippet = [snippet line];
end

end