function get_quotes
    curl -s -X GET -H "Content-Type: application/json" https://zenquotes.io/api/quotes >~/.config/fish/q.json
    echo 0 >~/.config/fish/.quotes_index
end

function display_next_quote
    set json_file ~/.config/fish/q.json
    set index_file ~/.config/fish/.quotes_index

    set index (cat $index_file)

    # Get the current quote based on index
    set quote (jq -r ".[$index]" $json_file)

    # Format and display the quote using lolcat
    echo $quote | jq -r '" " as $space | .q + "\n\n\($space * ((.q |length)-(.a |length) - 2)) --" + .a' | lolcat

    # Check if quotes file exists and is not empty
    if test -z (cat $json_file)
        get_quotes
    end

    # Read the current index

    # Get the total number of quotes
    #set total (jq length $json_file)

    # If index exceeds total quotes, fetch new quotes
    if test $index -ge 50
        get_quotes
        set index 0
    end
    # Extract the quote and author
    #set q (echo $quote | jq -r '.q')
    #et a (echo $quote | jq -r '.a')
    # Increment the index and save it
    echo (math $index+1) >$index_file
end
