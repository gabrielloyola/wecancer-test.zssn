# frozen_string_literal: true

module StatisticServices
  class Generator < ApplicationService
    def call
      generate_statistics
    end

    private

    def generate_statistics
      {
        infected_percentage: infected_percentage,
        not_infected_percentage: 100 - infected_percentage,
        item_averages: item_averages,
        lost_infected_points: lost_infected_points
      }
    end

    def infected_percentage
      (Survivor.where(infected: true).count / Survivor.count.to_f) * 100
    end

    def item_averages
      sum_by_name = InventoryItem.includes(:item, :survivor)
        .where('survivor.infected': false)
        .group('items.name')
        .sum('inventory_items.quantity')

      survivors_count = Survivor.where(infected: false).count

      sum_by_name.transform_values! { |item_sum| item_sum / survivors_count.to_f }
    end

    def lost_infected_points
      InventoryItem.includes(:item, :survivor)
        .where('survivor.infected': true)
        .pluck('items.value, inventory_items.quantity')
        .map { |value, quantity| value * quantity }
        .sum
    end
  end
end
