# frozen_string_literal: true

module ActiveadminAsyncExporter
  class Worker
    include Sidekiq::Worker

    def perform(options = {})
      controller = options['controller'].classify.constantize.new
      columns = options['columns']

      headers = columns.keys
      evaluators = columns.values

      path = "#{Rails.root.to_s}/tmp/#{filename(controller)}"
      
      CSV.open(path, 'wb', headers: true) do |csv|
        csv << headers.map { |key| key.to_s }

        collection(controller, options).find_in_batches do |group|
          group.each do |m|
            m = m.decorate if options['decorate_model']
            values = []
            evaluators.each do |ev|
              values << m.send(ev)
            end
            csv << values
          end
        end
      end
    end

    private

    def collection(controller, options)
      controller.scoped_collection.ransack(options['query']).result
    end

    def filename(controller)
      [controller.scoped_collection.name.pluralize.try(:downcase), Time.current.try(:to_i)].join('_') + '.csv'
    end
  end
end
