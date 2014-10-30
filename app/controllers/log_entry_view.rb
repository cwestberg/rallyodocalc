class LogEntryView < UIView
  
  # @table = UITableView.alloc.initWithFrame([[550,100], [450, 600]])
  # self.view.addSubview @table
  # table_delegate = LogEntryView.new
  # @table.dataSource = table_delegate
  # @table.delegate = table_delegate
  
  # ============ Table Stuff =============

  def tableView(tableView, numberOfRowsInSection:section)
    LogEntriesStore.shared.log_entries.size
  end
  # CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"
    # cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    log_entry = LogEntriesStore.shared.log_entries[indexPath.row]
    cell.textLabel.text = "#{log_entry.split} #{log_entry.action} }"
    cell
  end
  def tableView(tableView, didSelectRowAtIndexPath:indexPath) 
    puts "indexPath #{indexPath.inspect}" 
    log_entry = LogEntriesStore.shared.log_entries[indexPath.row]
    puts"#{log_entry.inspect}"
    if @selected_entry == log_entry
      tableView.deselectRowAtIndexPath(indexPath, animated:1)
      @selected_entry = nil
    else
      @selected_entry = log_entry
    end
    
  end
  def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    puts "editingStyleForRowAtIndexPath"
    UITableViewCellEditingStyleDelete
  end
  
  def tableView(tableView,commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    puts "commitEditingStyle"
    if editingStyle == UITableViewCellEditingStyleDelete
      # rows_for_section(indexPath.section).delete_at indexPath.row
      log_entry = LogEntriesStore.shared.log_entries[indexPath.row]
      LogEntriesStore.shared.remove_entry(log_entry)
      tableView.reloadData
    end 
  end
  def tableView(tableView, canMoveRowAtIndexPath:indexPath)
    return 1
  end
end