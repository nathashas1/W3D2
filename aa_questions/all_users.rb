require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :fname, :lname
  attr_reader :id
  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT
    *
    FROM
    users
    WHERE
    id = ?
    SQL
    return nil if user.length < 1
    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
    *
    FROM
    users
    WHERE
    fname = ? AND lname = ?

    SQL
    return nil if user.length < 1
    User.new(user.first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end

class Question
  attr_accessor :title, :body
  attr_reader :id, :user_id
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT
    *
    FROM
      questions
    WHERE
      id = ?
    SQL
    return nil if question.length < 1
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      user_id = ?
    SQL
    return nil if question.length < 1
    p question
    Question.new(question.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end

class Question_follow
  attr_reader :id, :question_id, :user_id

  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT
    *
    FROM
      question_follows
    WHERE
      id = ?
    SQL
    return nil if question_follow.length < 1
    Question_follow.new(question_follow.first)
  end


  def self.followers_for_question_id(question_id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    -- SELECT
    --   *
    -- FROM
    --   question_follows
    -- JOIN
    -- users
    -- ON users.id = question_follows.user_id
    -- WHERE question_follows.question_id = ?
      SELECT
        *
      FROM
        users
      WHERE
        id IN (
          SELECT
            user_id
          FROM
            question_follows
          WHERE
            question_id = ?
        )
    SQL
    ans = []
    return nil if question_follow.length < 1
    question_follow.each do |q|
      ans  << User.new(q)
    end
    ans
  end

  def self.followed_questions_for_user_id(user_id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      -- SELECT
      --   *
      -- FROM
      --   question_follows
      -- JOIN
      --   users
      -- ON
      --   question.id = question_follow.question_id
    SQL

  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end

class Reply
  attr_accessor :body
  attr_reader :id, :question_id, :user_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum)}
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT
    *
    FROM
      replies
    WHERE
      id = ?
    SQL
    return nil if reply.length < 1
    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL,user_id)
    SELECT
    *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    return nil if reply.length < 1
    Reply.new(reply.first)
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL,question_id)
    SELECT
    *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    return nil if reply.length < 1

    ans =[]
    reply.each do |el|
      ans << Reply.new(el)
    end
    ans
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_question_id(@question_id).first
  end

  def child_replies
    Reply.find_by_question_id(@question_id).last
  end
end

class Question_like
  attr_reader :id, :question_id, :user_id

  def self.find_by_id(id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL,id)
    SELECT
    *
    FROM
      question_likes
    WHERE
      id = ?
    SQL
    return nil if question_like.length < 1
    Question_follow.new(question_like.first)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
