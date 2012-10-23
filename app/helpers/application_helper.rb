module ApplicationHelper
	def get_color(index)
      color=['#FF6600','#008000','#FF99CC','#800080','#3366FF',
              '#99CCFF','#33CCCC','#993300','#333399','#FF00FF']
      return color[index]
    end
end
