# Vised Marks
The vised_marks extension for EEGLAB adds editing functions to the native eegplot 
data scrolling figure. Specifically, it allows adding/editing event markers, flagging 
channels/components, flagging time periods and displaying the 
properties of the marks structure. This extension provides an interface and "marks" 
data structure for managing the flagging of channels/components and time periods.
This extension also provides tools for epoching the data for artifact 
detection then concatenating the data back into a continuous form while storing the 
rejection information in the "marks" structure.

# Documentation
This plugin is part of BUCANL's [Lossless](https://github.com/BUCANL/BIDS-Lossless-EEG) EEG pipeline. As part of this, all tutorials and documentation are written using the Face13 dataset. Instructions on how to download and initialize this data can be found, [here](https://github.com/BUCANL/BIDS-Init-Face13-EEGLAB).

The reference manual for this plugin can be found on this repository's accompanying [wiki](https://github.com/BUCANL/Vised-Marks/wiki) page.

A tutorial with examples using the Face13 data can be found, [here](https://bucanl.github.io/SDC-VISED-MARKS/).

# Installation
This plugin can be installed with the plugin manager via EEGLAB. Additionally it can be installed by navigating to your `eeglab/plugins` folder and running the following command inside of a terminal:

```bash
git clone https://github.com/BUCANL/Vised-Marks.git
```

# Contact us
Please see the [Contact Us](https://github.com/BUCANL/Vised-Marks/wiki/Contact-Us) page if you have any questions.

# Attribution
Code initially designed and written by James A. Desjardins (SHARCNET) with contributions
from Andrew Lofts, Allan Campopiano, Mae Kennedy, Tyler Collins, Sara Stephenson, and Mike Cichonski supported by 
NSERC to Sidney J. Segalowitz at the Jack and Nora Walker Centre for Lifespan Development 
Research (Brock University), Brain Canada funding to Alan C. Evans at the Montreal 
Neurological Institute and Hospital (McGill University), and a Dedicated Programming 
award from SHARCNET, Compute Ontario.

# License / Copyright
Copyright (C) 2017 James Desjardins and others. This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program (LICENSE.txt file in the root directory); if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
