# PrettyPrompt
*Clean & stylish prompt for bash that will change your feel about using bash ever after.* 

![Screen Shot](https://github.com/ashikahmad/PrettyPrompt/wiki/screen_shot.png)

## Where did it come from?
Basically this idea of [PrettyPrompt] is brought to light based on the idea of vim's statusbar plugin [powerline] or [vim-powerline] (and later from [vim-airline]). Later I've *stolen* some code from another vim plugin [promptline] which does somewhat same thing in a different way.

It could be a question then why [PrettyPrompt] where there is already [promptline]. The answer is, the dependency to a vim plugin for creting even a simple prompt with style and how I can update the prompt with promptline looks a bit complex to me. And as I already came to a solution, I wanted to merge the **best of both**. But to be honest, promptline is awesome!

## Features

*  Easy configurable sections (and sub-sections), you'll see only what you want to (username > pretty-path > [git-branch & git-status] is set to show by default).
*  Show git branch with unstaged change indication by color (*green* for clean and *red* for changed by default).
*  Design as you wish: 
    *  colors (background and foreground of sections)
    *  charecters (section separator, sub-section seperator, git branch, ..)
    *  path format
    *  ... add more!
*  Can work any with regular font/unicode symbles, but look awesome with powerline symbols. One powerline font patch (Menlo) is added with this repo.

## Install

* Clone this repo your home dir: <br/>
   `git clone git@github.com:ashikahmad/PrettyPrompt.git ~/.bash_extra`
* Add this line to your .bash_profile/.bashrc:<br/>
   `[ -f ~/.bash_extra/pretty_prompt.sh ] && source ~/.bash_extra/pretty_prompt.sh`
* Install patched font (the one provided may be sufficient). See more in section below if needed.
* Re-open your terminal and see it's working!

## Configurations

.. todo ..

## Using Powerline patched font

.. todo ..


[vim-airline]:   https://github.com/bling/vim-airline
[vim-powerline]: https://github.com/Lokaltog/vim-powerline
[powerline]:     https://github.com/Lokaltog/powerline
[promptline]:    https://github.com/edkolev/promptline.vim
[PrettyPrompt]:  https://github.com/ashikahmad/PrettyPrompt  
