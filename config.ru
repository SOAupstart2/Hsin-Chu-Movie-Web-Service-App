# \ -s puma

Dir.glob('./{helpers,controllers,forms,services,values}/*.rb').each do |file|
  require file
end

run ApplicationController
