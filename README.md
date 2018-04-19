# Chef Repository Starter

This repository contains a base structure for a git repository to store environments, roles, and data bags for a 
[Chef](https://www.chef.io/) server. 

It also includes tooling written with [rake](https://github.com/ruby/rake) that, given a working 
[knife](https://docs.chef.io/knife.html) configuration, will automatically validate the json files and upload the to
the Chef server environment.

## Setup

To use this repo you will need the following:

- An account on the chef server with access to your organization
- A knife configuration
- A working ruby environment

### Configuring knife

You will need to create a `knife.rb` file for this repository. By default the tools in this repo will
 attempt to load `knife.rb` from your `~/.chef` folder. You can specify an alternative file with the 
 `CHEF_CLIENT_CONFIG` environment variable.

For managing multiple organizations with knife it is recommended to use [knife-block](https://github.com/knife-block/knife-block).

A sample configuration file is included in [configs/knife-example.rb](configs/knife-example.rb). Simply copy that file
and change the relevant values to match your chef user name nad the location of the necessary keys.

### Configuring ruby

Use [bundler](http://bundler.io/) to install the necessary ruby dependencies:

    bundle install
    
## Usage

This repository uses [rake](https://github.com/ruby/rake) to define tasks that verify the JSON files included in this 
repo and upload them to the Chef server. To see all available tasks run 

    bundle exec rake -T
    
You can update all environments, data bags, and roles using the default rake task with

    bundle exec rake
    
Also, you can specify only to update one category:
    
    bundle exec rake roles:upload
    
For roles and environments you can specify updating only a single file with:

    bundle exec rake roles:upload[www]
    bundle exec rake environments:upload[dev]
    
the included `verify` tasks will use [jsonlint](https://github.com/PagerDuty/jsonlint) to validate the 
included `.json` files. JSON files will always be validated before attempting to make any changes to the data in Chef.

### Data Bags

Data bags are stored under the [data_bags](data_bags) directory. Each sub-directory is treated as a data bag, and each 
json file in that directory will be uploaded as a separate data bag item for that bag.

If a new data bag directory is added a new data bag will be created on the Chef server before items are uplaoded.

#### Encrypted data bags

Any encrypted data bags should be encrypted _**before**_ they are stored in this repository. The easiest way to do this is to 
use knife to create the data bag, and then export the data bag to a json file after the fact. 

The workflow for new encrypted data bags is:

    knife data bag create $bag_name $item --secret-file ~/.chef/encrypted_data_bag_secret 

Knife will open the data bag in your default EDITOR. Add the data you want and save the file. Now export the encrypted 
data to a json file.

    mkdir data_bags/$bag_name
    knife data bag show $bag_name $item -Fj > data_bags/$bag_name/$item.json

By not specifying the encryption key the json output will only include the encrypted data.

Now you can check the new file into git. When you run the `data_bags:upload` task the encrypted values will be
synced with the Chef server.
    
### Rake

#### Adding new Rake tasks

Rake tasks are defined as `.rake` files in the [lib/tasks](lib/tasks) directory. Rake will load all of the tasks from 
directory by default. 

If you need to write helper classes or functions for your task store them as ruby files under
[lib/helpers](lib/helpers). These will also be automatically loaded by Rake at runtime. 