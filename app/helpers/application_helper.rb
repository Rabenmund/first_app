module ApplicationHelper

  def full_title(page_title)                          
    base_title = "Mein.Programm"                      
    if page_title.empty?                              
      base_title                                     
    else
      "#{base_title} | #{page_title}"
    end
  end

  def human_date(datetime)
    "#{"%02d" % datetime.day}.#{"%02d" % datetime.month}.#{datetime.year}"
  end
  
  def human_time(datetime)
    "#{"%02d" % datetime.hour}:#{"%02d" % datetime.min}"
  end
  
  def human_wday(datetime)
    case datetime.wday
    when 1
      day = "Montag"
    when 2 
      day = "Dienstag"
    when 3 
      day = "Mittwoch"
    when 4 
      day = "Donnerstag"
    when 5 
      day = "Freitag"
    when 6 
      day = "Samstag"
    when 0 
      day = "Sonntag"
    end
  end
  
  def small_human_wday(datetime)
    case datetime.wday
    when 1
      day = "Mo"
    when 2 
      day = "Di"
    when 3 
      day = "Mi"
    when 4 
      day = "Do"
    when 5 
      day = "Fr"
    when 6 
      day = "Sa"
    when 0 
      day = "So"
    end
  end
    
  # def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)  
  #   from_time = from_time.to_time if from_time.respond_to?(:to_time)  
  #   to_time = to_time.to_time if to_time.respond_to?(:to_time)  
  #   distance_in_minutes = (((to_time - from_time).abs)/60).round  
  #   distance_in_seconds = ((to_time - from_time).abs).round  
  #   
  #   case distance_in_minutes  
  #     when 0..1  
  #       return (distance_in_minutes == 0) ? 'weniger als einer Minute' : 'einer Minute' unless include_seconds  
  #       case distance_in_seconds  
  #         when 0..4   then 'weniger als 5 Sekunden'  
  #         when 5..9   then 'weniger als 10 Sekunden'  
  #         when 10..19 then 'weniger als 20 Sekunden'  
  #         when 20..39 then 'einer halben Minute'  
  #         when 40..59 then 'weniger als einer Minute'  
  #         else             '1 Minute'  
  #       end  
  # 
  #     when 2..44           then "#{distance_in_minutes} Minuten"  
  #     when 45..89          then 'ca. 1 Stunde'  
  #     when 90..1439        then "ca. #{(distance_in_minutes.to_f / 60.0).round} Stunden"  
  #     when 1440..2879      then '1 Tag'  
  #     when 2880..43199     then "#{(distance_in_minutes / 1440).round} Tagen"  
  #     when 43200..86399    then 'ca. 1 Monat'  
  #     when 86400..525599   then "#{(distance_in_minutes / 43200).round} Monaten"  
  #     when 525600..1051199 then 'ca. 1 Jahr'  
  #     else                      "#{(distance_in_minutes / 525600).round} Jahren"  
  #   end  
  # end

  
end