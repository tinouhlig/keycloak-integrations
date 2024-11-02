package com.example.spring.access.controller;

import com.example.spring.access.entity.Access;
import com.example.spring.access.repository.AccessRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TestController {

    AccessRepository accessRepository;

    Logger logger = LoggerFactory.getLogger(TestController.class);

    TestController(AccessRepository accessRepository) {
        this.accessRepository = accessRepository;
    }

    @RequestMapping(path = "/test", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Access> test() {
        logger.info("test");
        List<Access> accessEntitities = this.accessRepository.findAll();
        return accessEntitities;
    }

}
