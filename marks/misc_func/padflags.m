% Function which given an array 'flags' of values, prepends and appends a value
% around a given nonzero block of data in the given array.
% This value can be customized via the vararg 'value'. (e.g. 'value',0.5)
function flags=padflags(EEG,flags,npad,varargin)

g=struct(varargin{:});

try g.value; catch, g.value=1; end;

for np=1:npad;
    for i=1:size(flags,3)-1;
        %forward...
        if any(flags(:,:,i+1)) && ~any(flags(:,:,i))
            flags(:,:,i)=g.value;
        end
        %backward...
        if any(flags(:,:,(EEG.trials-(i-1))-1)) && ~any(flags(:,:,EEG.trials-(i-1)))
            flags(:,:,EEG.trials-(i-1))=g.value;
        end
    end
end
