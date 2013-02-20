module ApplicationHelper
def sortable(column, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "current #{sort_direction}" : nil
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title, {:sort => column, :direction => direction}, {:class => css_class}
end

def help
@help_text_1 = "To perform operations on other machine via ssh:
		ssh remote-host-name <<'ENDSSH'
		# commands to run...
		ENDSSH"
end

end
