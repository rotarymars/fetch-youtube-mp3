          if [ ! -d "music" ]; then
            mkdir "music"
          fi

          while IFS=' ' read -r url pitch || [ -n "$url" ]; do
            url=$(echo "$url" | xargs)
            pitch=$(echo "$pitch" | xargs)
            echo "Processing URL: $url"
            echo "Pitch shift: $pitch semitones"
            video_title=$(yt-dlp --get-title "$url" 2>/dev/null)
            video_id=$(yt-dlp --get-id "$url" 2>/dev/null)
            clean_title=$(echo "$video_title" | sed 's/[^a-zA-Z0-9._-]/_/g' | sed 's/__*/_/g' | sed 's/^_//;s/_$//')
            temp_file="temp_${video_id}.mp3"
            output_file="music/${clean_title}_${video_id}_pitch${pitch}.mp3"
            
            echo "Video Title: $video_title"
            echo "Video ID: $video_id"
            echo "Output file: $output_file"
            
            yt-dlp -x --audio-format mp3 -o "$temp_file" "$url"
            rubberband -p "$pitch" "$temp_file" "$output_file"
            
            rm "$temp_file"
            echo "Completed processing '$video_title' with pitch $pitch"
            echo "---"
          done < list.txt
