namespace :platypus do
  desc "Fill countries"
  task fill_countries: :environment do
    loader = PageLoader.new

    loader.load_countries
  end
end
