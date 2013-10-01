# encoding: utf-8

module Elasticsearch
  module Extensions
    module ANSI

      module Helpers

        # Shortcut for {::ANSI::Table.new}
        #
        def table(data, options={}, &format)
          ::ANSI::Table.new(data, options, &format)
        end

        # Terminal width, based on {::ANSI::Terminal.terminal_width}
        #
        def width
          ::ANSI::Terminal.terminal_width-5
        end

        # Humanize a string
        #
        def humanize(string)
          string.to_s.gsub(/\_/, ' ').split.map { |s| s.capitalize}.join(' ')
        end

        # Return date formatted by interval
        #
        def date(date, interval='day')
          case interval
            when 'minute'
              date.strftime('%a %m/%d %H:%M') + ' – ' + (date+60).strftime('%H:%M')
            when 'hour'
              date.strftime('%a %m/%d %H:%M') + ' – ' + (date+60*60).strftime('%H:%M')
            when 'day'
              date.strftime('%a %m/%d')
            when 'week'
              days_to_monday = date.wday!=0 ? date.wday-1 : 6
              days_to_sunday = date.wday!=0 ? 7-date.wday : 0
              start = (date - days_to_monday*24*60*60).strftime('%a %m/%d')
              stop  = (date+(days_to_sunday*24*60*60)).strftime('%a %m/%d')
              "#{start} – #{stop}"
            when 'month'
              date.strftime('%B %Y')
            when 'year'
              date.strftime('%Y')
            else
              date.strftime('%Y-%m-%d %H:%M')
          end
        end

        # Output divider
        #
        def ___
          ('─'*Helpers.width).ansi(:faint)
        end

        extend self
      end

    end
  end
end
