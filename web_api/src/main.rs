use {
    actix_web::{
        App,
        get,
        HttpResponse,
        HttpServer,
        Responder
    },
    std::env
};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Secret Hitler's API")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();

    println!("Len of args: {}.", args.len());
    println!("Arg[0] is: {}.", &args[0]);

    let mut address: String = "0.0.0.0".to_string();
    let mut port: u16 = 8000;

    //  1st argument is the binary command
    if (args.len() - 1) == 2 {
        address = (&args[1]).clone();
        port = (&args[2]).parse().unwrap();
    } else if (args.len() - 1) == 1 {
        port = (&args[1]).parse().unwrap();
    }

    let address = address;
    let port = port;

    println!("Running on port {} on host {}.", port, address);
    println!("http://{}:{}/", address, port);

    HttpServer::new(move || {
        App::new()
            .service(hello)
    })
        .bind(format!("{}:{}", address, port))?
        .run()
        .await
}
