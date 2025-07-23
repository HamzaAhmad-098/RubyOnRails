class EvaluationsController < ApplicationController
  include Rails.application.routes.url_helpers

  def new
    @evaluation = Evaluation.new
  end

  def create
    @evaluation = Evaluation.new(evaluation_params)

    # First save without image to get ID
    if @evaluation.save
      # Attach image if present (after initial save)
      if params[:evaluation][:answer_image].present?
        @evaluation.answer_image.attach(params[:evaluation][:answer_image])
      end

      # Generate URL for attached image
      image_url = @evaluation.answer_image.attached? ? 
                  rails_blob_url(@evaluation.answer_image) : 
                  nil

      # Call AI grader
      result = AiGrader.new.evaluate(
        @evaluation.question_text,
        @evaluation.student_answer,
        @evaluation.marks,
        @evaluation.instructions,
        image_url
      )

      # Update with AI results
      @evaluation.update(
        ai_score: result[:score],
        ai_feedback: result[:feedback],
        mistakes_summary: result[:mistakes].to_json
      )

      redirect_to @evaluation, notice: "AI evaluation complete."
    else
      render :new
    end
  end

  def show
    @evaluation = Evaluation.find(params[:id])
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:question_text, :student_answer, :marks, :instructions)
  end
end