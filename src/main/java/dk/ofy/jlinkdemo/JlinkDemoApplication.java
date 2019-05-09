package dk.ofy.jlinkdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@SpringBootApplication
public class JlinkDemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(JlinkDemoApplication.class, args);
	}

	@RestController
	class DemoController {
		@GetMapping
		public String hello() {
			return "It is "+new Date()+" and i say hello!";
		}
	}
}

