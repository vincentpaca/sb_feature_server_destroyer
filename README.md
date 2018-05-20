# How to use
You can run the script with `./script/run.rb kill staging_servers`

# Setup
- This was tested with ruby-2.5.1.
- Run `bundle`

# Design

### Command Dispatch Module
I decided to use my command line dispatcher module to make running scripts look better and sensible.
 
This module supports adding arguments to commands too.

The structure is pretty straightforward, see `script/command_runner/command.rb` to see how commands are added.

### AWS SDK
I used `aws-sdk-ec2` to query instances with the `feature` ENV tag.
It's nice that the 3rd version of the `aws-sdk` separates different services to different gems now. 

### SSH
I used `sshkit` from Capistrano so I can SSH into servers, and run commands on them. Pretty simple integration.

# See it in action
You can see a short video of how it works in action [here.](http://recordit.co/IX9Puyzxw9)
