function properties = visedconfig2propgrid(vised_config)

if nargin==0;
    
    try parameters = evalin('base', 'vised_config');
        vised_config=parameters;
    catch %if nonexistent in workspace
        vised_config=init_vised_config;
    end

end

if iscell(vised_config.color);
    for i=1:length(vised_config.color);
        if isnumeric(vised_config.color{i})
            vised_config.color{i}=num2str(vised_config.color{i});
        end
    end
else
    vised_config.color={vised_config.color};
end

properties = [ ...
    PropertyGridField('quick_evtmk', vised_config.quick_evtmk, ...
    'Type', PropertyType('char','row',''), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'quick event create', ...
    'Description', ...
        ['String event type to immediately add (without pop up window) when ',...
        'alternate press ([ctrl + left-click] or [right-click]) is executed ', ...
        'on the eegplot data axis. This option overwrites any other specification ', ...
        'for altselectcommand at run time [Default = '' = no quick event].']) ...
    PropertyGridField('quick_evtrm', vised_config.quick_evtrm, ...
    'Type', PropertyType('char','row',{'off','ext_press','alt_press'}), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'quick event remove', ...
    'Description', ['Enable single click event removal (no pop up GUI). ' ...
    '"ext_press" = remove event when [Shift + left-click] is executed on events in the eegplot figure axis, '...
    '"alt_press" = remove event when [Ctrl + left-click] or [righ-click] is executed on events in the eegplot figure axis. ' ...
    'When set to "alt_press" this option will overwrite any other specification for altselectcommand at run time.' ...
    'When set to "ext_select" this option will overwrite any other specification for extselectcommand (including quick_evtmk) at run time.']) ...
    PropertyGridField('quick_chanflag', vised_config.quick_chanflag, ...
    'Type', PropertyType('char','row',{'off','ext_press','alt_press'}), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'quick channel flagging', ...
    'Description', ['Enable single click channel flag toggle (no pop up GUI). ' ...
    '"alt press" = toggle channel flag when Shift-left-click is executed on event in eegplot figure axis, '...
    '"ext press" = toggle channel flag when Ctrl-left-click [or simple righ-click] is executed on event in eegplot figure axis']) ...
    PropertyGridField('selectcommand', vised_config.selectcommand, ...
    'Type', PropertyType('cellstr','column'), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'select command [selectcommand]', ...
    'Description', ['[cell array] list of 3 commands (strings) to run when the mouse ' ...
                      'button is down, when it is moving and when the mouse button is up.']) ...
    PropertyGridField('extselectcommand', vised_config.extselectcommand, ...
    'Type', PropertyType('cellstr','column'), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'extended select command [extselectcommand]', ...
    'Description', ['[cell array] list of 3 commands (strings) to run when the mouse ' ...
                      'button + SHIFT is down, when it is ' ...
                      'moving and when the mouse button is up.']) ...
    PropertyGridField('altselectcommand', vised_config.altselectcommand, ...
    'Type', PropertyType('cellstr','column'), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'alternate select command [altselectcommand]', ...
    'Description', ['[cell array] list of 3 commands (strings) to run when the mouse ' ...
                      'button + CTRL (or simple right press) is down, when it is ' ...
                      'moving and when the mouse button is up.']) ...
    PropertyGridField('keyselectcommand', vised_config.keyselectcommand, ...
    'Type', PropertyType('cellstr','column'), ...
    'Category', 'visual editing options', ...
    'DisplayName', 'key select command [keyselectcommand]', ...
    'Description', ['[cell array] each row is string containing a key character ' ...
                    'followed by "," then a command to execute when the key character ' ...
                    'is pressed while the pointer is over the data axis.']) ...
    PropertyGridField('mouse_data_front', vised_config.mouse_data_front, ...
    'Type', PropertyType('char','row',{'on','off'}), ...
    'DisplayName', 'Keep figure at front [mouse_data_front]', ...
    'Category', 'eegplot options', ...
    'Description', ['[''on''|''off''] When mouse moves over the data axis bring/keep', ...
                    ' the eegplot figure window at the front {default: ''on''}']) ...
...
...
    PropertyGridField('marks_y_loc', vised_config.marks_y_loc, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'marks property options', ...
    'DisplayName', 'marks y axis location [marks_y_loc]', ...
    'Description', ['Location along the y axis [percent from bottom to top] ' ...
                    'to diplay the marks structure flags {default .8}. May also ' ...
                    'be an array of values to plot ']) ...
    PropertyGridField('inter_mark_int', vised_config.inter_mark_int, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'marks property options', ...
    'DisplayName', 'inter-mark interval [inter_mark_int]', ...
    'Description', ['Distance along the y axis [percent from bottom to top] ' ...
                    'to separate each marks type {default .04}.']) ...
    PropertyGridField('inter_tag_int', vised_config.inter_tag_int, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'marks property options', ...
    'DisplayName', 'inter-tag interval [inter_tag_int]', ...
    'Description', ['Distance along the x axis [percent from left to right] ' ...
                    'to separate each channel tag pointing at flagged channel labels {default .002}.']) ...
    PropertyGridField('marks_col_int', vised_config.marks_col_int, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'marks property options', ...
    'DisplayName', 'color interval for marks display [marks_col_int]', ...
    'Description', ['Marks surface plots depict values between 0 to 1. ' ...
                    'The marks_col_int sets the interval of color change in the plot {default .1}.']) ...
    PropertyGridField('marks_col_alpha', vised_config.marks_col_alpha, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'marks property options', ...
    'DisplayName', 'marks surface plot transparency [marks_col_alpha]', ...
    'Description', ['Alpha is a value between 0 and 1 where 0 = transparent and 1 = opaque {default .7}.']) ...
...
...
    PropertyGridField('spacing', vised_config.spacing, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'Y axis spacing [spacing]', ...
    'Description', ['Display range per channel (default|0: max(whole_data)-min(whole_data))' ...
                    'Y axis distance in uV between the zero value of', ...
                    'each waveform in the eegplot scroll window.']) ...
    PropertyGridField('limits', vised_config.limits, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'time limits [limits]', ...
    'Description', ['[start end] Time limits for data epochs in ms (for labeling' ... 
                    'purposes only).']) ...
    PropertyGridField('winlength', vised_config.winlength, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'window time length [winlength]', ...
    'Description', ['[value] Seconds (or epochs) of data to display in window {default: 5}']) ...
    PropertyGridField('dispchans', vised_config.dispchans, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'n channels to display [dispchans]', ...
    'Description', ['[integer] Number of channels to display in the activity window ' ...
                   '{default: from data}.  If < total number of channels, a vertical ' ... 
                   'slider on the left side of the figure allows vertical data scrolling.']) ...
    PropertyGridField('title', vised_config.title, ...
    'Type', PropertyType('char','row'), ...
    'DisplayName', 'title', ...
    'Category', 'eegplot options', ...
    'Description', ['Figure title {default: none}']) ...
    PropertyGridField('xgrid', vised_config.xgrid, ...
    'Type', PropertyType('char','row',{'on','off'}), ...
    'DisplayName', 'X axis grid lines [xgrid]', ...
    'Category', 'eegplot options', ...
    'Description', ['[''on''|''off''] Toggle display of the x-axis grid {default: ''off''}']) ...
    PropertyGridField('ygrid', vised_config.ygrid, ...
    'Type', PropertyType('char','row',{'on','off'}), ...
    'DisplayName', 'Y axis grid lines [ygrid]', ...
    'Category', 'eegplot options', ...
    'Description', ['[''on''|''off''] Toggle display of the y-axis grid {default: ''off''}']) ...
    PropertyGridField('ploteventdur', vised_config.ploteventdur, ...
    'Type', PropertyType('char','row',{'on','off'}), ...
    'DisplayName', 'plot event duration [ploteventdur]', ...
    'Category', 'eegplot options', ...
    'Description', ['[''on''|''off''] Toggle display of event duration { default: ''off'' }']) ...
    PropertyGridField('data2', vised_config.data2, ...
    'Type', PropertyType('char','row'), ...
    'DisplayName', 'ovelay data', ...
    'Category', 'eegplot options', ...
    'Description', ['[float array] identical size to the original data and ' ...
                   'plotted on top of it.']) ...
...
    PropertyGridField('command', vised_config.command, ...
    'Type', PropertyType('char','row'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'button command [command]', ...
    'Description', ['[''string''] Matlab command to evaluate when the ''REJECT'' button is ' ...
                   'clicked. The ''REJECT'' button is visible only if this parameter is ' ...
                   'not empty. As explained in the "Output" section below, the variable ' ...
                   '''TMPREJ'' contains the rejected windows (see the functions ' ...
                   'eegplot2event() and eegplot2trial()).']) ...
    PropertyGridField('butlabel', vised_config.butlabel, ...
    'Type', PropertyType('char','row'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'button label [butlabel]', ...
    'Description', ['Reject button label. {default: ''REJECT''}']) ...
PropertyGridField('color', vised_config.color, ...
'Type', PropertyType('cellstr','column'), ...
'Category', 'eegplot options', ...
'DisplayName', 'channel color [color]', ...
'Description', ['[''on''|''off''|cell array] Plot channels with different colors. ' ...
'If an RGB cell array {''r'' ''b'' ''g''}, channels will be plotted ' ...
'using the cell-array color elements in cyclic order {default:''off''}.']) ...
...
PropertyGridField('wincolor', vised_config.wincolor, ...
'Type', PropertyType('denserealdouble','matrix'), ...
'Category', 'eegplot options', ...
'DisplayName', 'axis marking color [wincolor]', ...
'Description', ['[color] Color to use to mark data stretches or epochs {default: ' ...
'[ 0.7 1 0.9]}']) ...
    PropertyGridField('submean', vised_config.submean, ...
    'Type', PropertyType('char','row',{'on','off'}), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'subtract signal mean [submean]', ...
    'Description', ['[''on''|''off''] Remove channel means in each window {default: ''on''}']) ...
    PropertyGridField('position', vised_config.position, ...
    'Type', PropertyType('denserealdouble','matrix'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'figure window [position]', ...
    'Description', ['[lowleft_x lowleft_y width height] Position of the figure in pixels.']) ...
    PropertyGridField('tag', vised_config.tag, ...
    'Type', PropertyType('char','row'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'figure window [tag]', ...
    'Description', ['[string] Matlab object tag to identify this eegplot() window (allows ' ...
                    'keeping track of several simultaneous eegplot() windows).']) ...
    PropertyGridField('children', vised_config.children, ...
    'Type', PropertyType('char','row'), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'figure [children] handle', ...
    'Description', ['[integer] Figure handle of a *dependent* eegplot() window. Scrolling ' ...
                    'horizontally in the master window will produce the same scroll in ' ...
                    'the dependent window. Allows comparison of two concurrent datasets, ' ...
                    'or of channel and component data from the same dataset.']) ...
    PropertyGridField('scale', vised_config.scale, ...
    'Type', PropertyType('char','row',{'on','off'}), ...
    'Category', 'eegplot options', ...
    'DisplayName', 'amplitude [scale]', ...
    'Description', ['[''on''|''off''] Display the amplitude scale {default: ''on''}.']) ...
];
