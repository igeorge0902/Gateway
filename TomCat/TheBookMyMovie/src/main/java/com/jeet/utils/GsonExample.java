package com.jeet.utils;

import com.google.gson.Gson;

import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class GsonExample {

    public static void main(String[] args) {

        Staff staff = createDummyObject();
        Staff staff_ = createDummyObject();
        
        List<Staff> list = new ArrayList<Staff>();
        list.add(staff_);
        list.add(staff);

        //1. Convert object to JSON string
        Gson gson = new Gson();
        String json = gson.toJson(staff);
        System.out.println(json);
        
        String json_ = gson.toJson(list);
        System.out.println(json_);


    }

    private static Staff createDummyObject() {

        Staff staff = new Staff();

        staff.setName("mkyong");
        staff.setAge(35);
        staff.setPosition("Founder");
        staff.setSalary(new BigDecimal("10000"));

        List<String> skills = new ArrayList<>();
        skills.add("java");
        skills.add("python");
        skills.add("shell");

        staff.setSkills(skills);

        return staff;

    }

}