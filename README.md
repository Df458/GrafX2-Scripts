# GrafX2-Scripts
This is just a collection of small quality-of-life scripts that I've written to make my life easier.

All scripts make use of the 'memory.lua' script from GrafX2's sample scripts.
If you don't have it or don't want to copy it over, you can change the line at the top of any script from
`has_memory = true;`
to
`has_memory = false;`
This will prevent the script from loading the memory library, but as a result it won't remember your last options.

# The Scripts
## APage.lua
Copy the second page to the currently active page, placing the image data next to the current contents.
This copy preserves layer information for easy comparisons!
## AnimToSpritesheet.lua
Converts an animation (or a collection of layers) to a spritesheet on the second page. Pretty strightforward.
## ZinP
Places a scaled copy of your image next to the original, preserving layer information.
This is mostly useful for sharing pixel art with a scaled-up version for detailed viewing.
Since it preserves layer information, ZinP works just as well with animations as with static images.
