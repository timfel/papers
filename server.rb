class Backend < Thin::Backends::TcpServer

  def initialize(host, port, options={})
    super(host, port)
  end

  def connection_finished(connection)
    super(connection)

    if connection.request.env["query_killer"]
      connection.request.env["query_killer"].kill
    end

  end

end

