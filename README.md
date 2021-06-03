# liquid-tetris

- 11:30AM, started implementing a way for each block to have a grounding check
- 12:08AM, changed grounding check to committing block to background, but this isn't being updated for blocks higher than one block above. this works other than the fact that 3-high falling tetrominoes get reduced into 2-blocks.
- 12:15AM, figured out need to make a full function to redetermine grounding of every point that forms it into background
- 12:45AM, reevalute grounding finally works but it's one frame late

- 1:05AM, tried to add liquid flowing and mostly works but some blocks are eaten up
- 3:04AM, figured out if a block is going down, i just need to check all its neighbors to see if they are planning to go into my spot and if so then stall
