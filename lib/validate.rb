class Validate
  def coordinate_translation(human_notation)
    matrix_notation = []
    matrix_notation[0] = human_notation[0].upcase.ord - "A".ord
    matrix_notation[1] = human_notation[1..-1].to_i - 1
    matrix_notation
  end

  def same_row_or_column?(coordinate0, coordinate1)
    coordinate0[0] == coordinate1[0] || coordinate0[1] == coordinate1[1]
  end

  def distance(coordinate0, coordinate1)
    (coordinate0[0] - coordinate1[0]).abs +
    (coordinate0[1] - coordinate1[1]).abs
  end
end
