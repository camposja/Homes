namespace :shrine do
  desc "Regenerate image derivatives with options for specific homes and batch size"
  task :regenerate_derivatives, [:batch_size, :home_ids] => :environment do |_t, args|
    args.with_defaults(batch_size: 50)
    
    puts "Starting image derivatives regeneration..."
    puts "Batch size: #{args.batch_size}"
    puts "Specific home IDs: #{args.home_ids}" if args.home_ids.present?
    
    # Build the query based on arguments
    homes = Home.where(image_data: /.*/)  # Only homes with images
    if args.home_ids.present?
      home_ids = args.home_ids.split(',').map(&:strip)
      homes = homes.where(id: home_ids)
    end
    
    total = homes.count
    processed = 0
    errors = []
    
    homes.find_each(batch_size: args.batch_size.to_i) do |home|
      processed += 1
      print "\rProcessing #{processed}/#{total} (#{(processed.to_f/total * 100).round(1)}%)"
      
      begin
        attacher = home.image_attacher
        if attacher.file.present?
          # Store original metadata before regenerating
          original_metadata = attacher.file.metadata.dup
          
          # Regenerate derivatives
          attacher.create_derivatives
          
          # Only save if derivatives actually changed
          if attacher.file.metadata != original_metadata
            home.save
            print " - Updated"
          else
            print " - No changes needed"
          end
        end
      rescue => e
        error_msg = "Error processing home #{home.id}: #{e.message}"
        errors << error_msg
        print " - Error!"
      end
    end
    
    puts "\n\nProcessing complete!"
    puts "Total processed: #{processed}"
    puts "Successful: #{processed - errors.size}"
    puts "Errors: #{errors.size}"
    
    if errors.any?
      puts "\nErrors encountered:"
      errors.each { |error| puts "- #{error}" }
    end
  end

  desc "Migrate old image records to new format with progress tracking"
  task :migrate_old_images, [:batch_size] => :environment do |_t, args|
    args.with_defaults(batch_size: 50)
    
    puts "Starting migration of old image records..."
    puts "Batch size: #{args.batch_size}"
    
    # Find homes with old image format
    homes = Home.where(image_data: /.*/)
    total = homes.count
    processed = 0
    migrated = 0
    errors = []
    
    homes.find_each(batch_size: args.batch_size.to_i) do |home|
      processed += 1
      print "\rProcessing #{processed}/#{total} (#{(processed.to_f/total * 100).round(1)}%)"
      
      if home.image_data.present?
        begin
          data = JSON.parse(home.image_data)
          
          # Check if this is an old format record
          needs_migration = data["derivatives"].nil? && data.key?("storage")
          
          if needs_migration
            attacher = home.image_attacher
            if attacher.file.present?
              attacher.create_derivatives
              home.save
              migrated += 1
              print " - Migrated"
            end
          else
            print " - Already migrated"
          end
        rescue JSON::ParserError
          error_msg = "Error parsing JSON for home #{home.id}"
          errors << error_msg
          print " - Invalid JSON!"
        rescue => e
          error_msg = "Error migrating home #{home.id}: #{e.message}"
          errors << error_msg
          print " - Error!"
        end
      end
    end
    
    puts "\n\nMigration complete!"
    puts "Total processed: #{processed}"
    puts "Successfully migrated: #{migrated}"
    puts "Already up to date: #{processed - migrated - errors.size}"
    puts "Errors: #{errors.size}"
    
    if errors.any?
      puts "\nErrors encountered:"
      errors.each { |error| puts "- #{error}" }
    end
  end
  
  desc "Display image statistics for the application"
  task stats: :environment do
    puts "Gathering image statistics..."
    
    total_homes = Home.count
    homes_with_images = Home.where(image_data: /.*/).count
    
    puts "\nImage Statistics:"
    puts "----------------"
    puts "Total homes: #{total_homes}"
    puts "Homes with images: #{homes_with_images}"
    puts "Homes without images: #{total_homes - homes_with_images}"
    puts "Image coverage: #{(homes_with_images.to_f/total_homes * 100).round(1)}%"
    
    if homes_with_images > 0
      sample = Home.where(image_data: /.*/).first
      if sample&.image_data.present?
        data = JSON.parse(sample.image_data)
        puts "\nAvailable derivatives:"
        data["derivatives"]&.keys&.each { |key| puts "- #{key}" }
      end
    end
  end
end 