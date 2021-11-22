# os-probe

Dead simple dashboard for machine metrics and jobs

## Testing

`crystal spec`

* to run in development mode `crystal ./src/app.cr`

## Compiling

`crystal build ./src/app.cr`

## Deploying

Once compiled you are left with a binary `./app`

* for help `./app --help`
* viewing routes `./app --routes`
* run on a different port or host `./app -b 0.0.0.0 -p 80`

Static builds for the following architectures are also available inside the dist/ folder:

* amd64

Copy the binary to the main project folder, mark it as executable and your good to go!

## Changelog

### **v0.2.0**

**Current Features**
- Completely self-contained
- Displays basic info about processes, disk usage and services
- Static binary compiled with libressl under Alpine Linux 3.15

**TODO**
- Get system metrics using hardware shard instead of running command-line utilities
- Integrate [mitamae](https://github.com/itamae-kitchen/mitamae) utility for configuration management
- Log system metrics in the background (details below)
- Implement SpiderGazelle::ActiveModel#save using Totem Yaml serialization
- Implement specific endpoints for each metric, return json for easy integration
- Constantly update info on the frontend using ajax calls
- Integrate charting library using javascript
- Logrotate functionality for stored system metrics


